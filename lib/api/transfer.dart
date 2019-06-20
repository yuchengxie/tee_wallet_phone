import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/src/sha256.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:buffer/buffer.dart';
import 'package:http/http.dart' as http;
import './pack/pack.dart';
import './pack/unpack.dart';
import '../model/jsonEntity.dart';
import '../model/message.dart';
import './scripts/opscript.dart';
import './utils/utils.dart';

const WEB_SERVER_ADDR = 'http://user1-node.nb-chain.net';
var sequence = 0,
    _wait_submit = [],
    SHEET_CACHE_SIZE = 16,
    txn_binary,
    hash_,
    state_info,
    sn,
    tx_ins2 = [],
    tx_ins_len,
    pks_out0,
    hash_type = 1,
    submit = true;

TeeWallet _wallet;
final magic = [0xf9, 0x6e, 0x62, 0x74];
MakeSheet makesheet;
OrgSheet orgSheet;

void main() {
  query_sheet('', '');
}

void query_sheet(pay_to, from_uocks) async {
  int ext_in = 0;
  bool submit = true;
  int scan_count = 0;
  int min_utxo = 0;
  int max_utxo = 0;
  int sort_flag = 0;
  int from_uocks = 0;
  var bytes1 = prepare_txn1_(pay_to, ext_in, submit, scan_count, min_utxo,
      max_utxo, sort_flag, from_uocks);
  String s1 = bytesToHexStr(bytes1);
  print('1准备发送数据:${s1}--${s1.length}');
  final url = WEB_SERVER_ADDR + '/txn/sheets/sheet';
  final response = await http.post(url, body: bytes1);
  final response_bytes = response.bodyBytes;
  String s = bytesToHexStr(response_bytes);
  print('1接收到数据${s}---${s.length}');
  List<int> payload = getPayload(response_bytes);
  if (payload == null) {
    return;
  }
  String s2 = bytesToHexStr(payload);
  print('${s2}---${s2.length}');
  orgSheet = orgSheetParse(payload);
  //网络获取钱包
  final url2 = 'http://127.0.0.1:3000/get_wallet';
  final response2 = await http.get(url2);
  if (response2.statusCode != 200) {
    print('not found wallet');
    return;
  }
  final _json = json.decode(response2.body);
  _wallet = TeeWallet.fromJson(_json);
  print('wallet_json:${_json}');
  List<int> coin_hash = hexStrToBytes(_wallet.pub_hash + '00');
  print(coin_hash);

  var d = {};
  var _pay_to = makesheet.pay_to;
  for (var i = 0; i < _pay_to.length; i++) {
    var p = _pay_to[i];
    List<int> _add = strToBytes(p.address);
    if (p.value != 0 || _add.sublist(0, 1) != 0x6a) {
      Uint8List ret = decode_check(p.address).sublist(1);
      if (ret == null) {
        continue;
      }
      String ret_str = bytesToHexStr(ret);
      d[ret_str] = p.value;
    }
  }

  for (int idx = 0; idx < orgSheet.tx_out.length; idx++) {
    var item = orgSheet.tx_out[idx];
    if (item.value == 0 && item.pk_script.substring(0, 1) == '') {
      continue;
    }
    //脚本操作
    String addr = process(item.pk_script).split(' ')[2];
    if (addr == null) {
      print('Error: invalid output address (idx=${idx})');
    } else {
      var value_ = d[addr];
      if (value_ != null) {
        d.remove(d[addr]);
      } else {
        continue;
      }
      if (item.value != value_) {
        if (value_ == null && addr.substring(4) == bytesToHexStr(coin_hash)) {
        } else {
          print('Error: invalid output value (idx=${idx})');
        }
      }
    }
  }

  for (var k in d.keys) {
    print('${k}--${d[k]}');
    // if(coin_hash!=addr)
  }

  var pks_out0 = orgSheet.pks_out[0].items;
  var pks_num = pks_out0.length;
  List<TxIn> tx_ins2 = List<TxIn>();
  for (int idx = 0; idx < orgSheet.tx_in.length; idx++) {
    if (idx < pks_num) {
      TxIn tx = orgSheet.tx_in[idx];
      int hash_type = 1;
      Uint8List sign_payload = script_payload(pks_out0[idx], orgSheet.version,
          orgSheet.tx_in, orgSheet.tx_out, 0, idx, hash_type);
      String s = bytesToHexStr(sign_payload);
      print('>>> ready sign payload:${s}---${s.length}');
      //本地服务tee签名
      final url_sign = 'http://127.0.0.1:3000/get_sign';
      final sign_params = {'payload': s, 'pincode': '000000'};
      final response_sign = await http.post(url_sign, body: sign_params);
      if (response_sign.statusCode != 200) {
        print('sign err');
        return;
      }
      final _json_sign = json.decode(response_sign.body);
      print('_json_sign:${_json_sign}');
      TeeSign teeSign = TeeSign.fromJson(_json_sign);
      print('tee_sign:${teeSign.msg}');
      // List<int> _sig = hexStrToBytes(teeSign.msg);
      List<int> sig = new List<int>.from(hexStrToBytes(teeSign.msg))
        ..addAll(CHR(hash_type));
      print('sig:${bytesToHexStr(sig)}');

      List<int> sig_script = List.from(CHR(sig.length))
        ..addAll(sig)
        ..addAll(CHR(hexStrToBytes(_wallet.pub_key).length))
        ..addAll(hexStrToBytes(_wallet.pub_key));
      print('sig_script:${bytesToHexStr(sig_script)}');
      tx_ins2.add(TxIn(
          prev_output: tx.prev_output,
          sig_script: bytesToHexStr(sig_script),
          sequence: tx.sequence));
    }
  }

  Transaction txn = Transaction(
      version: orgSheet.version,
      tx_in: tx_ins2,
      tx_out: orgSheet.tx_out,
      lock_time: orgSheet.lock_time,
      sig_raw: '');
  List<int> txn_payload = txnPayload(txn);
  txn_payload=wholePayload(txn_payload, txn.command);
  var t = bytesToHexStr(txn_payload);
  print('txn_payload:${t}');
}

// void waitSubmit(List<int> bytes) {}

List<int> prepare_txn1_(pay_to, ext_in, submit, scan_count, min_utxo, max_utxo,
    sort_flag, from_uocks) {
  sequence += 1;
  List<PayFrom> pay_from = List<PayFrom>();
  PayFrom pay_from1 = PayFrom();
  pay_from1.value = 0;
  pay_from1.address = '13TtvKn5cwNhdxfXSbz1MewRnTEPB534rudq41LnRP1T9A4TJmjAKhJ';
  pay_from.add(pay_from1);

  List<PayTo> pay_to = List<PayTo>();
  PayTo pay_to1 = PayTo();
  pay_to1.value = 100000000;
  pay_to1.address = '1118hfRMRrJMgSCoV9ztyPcjcgcMZ1zThvqRDLUw3xCYkZwwTAbJ5o';
  pay_to.add(pay_to1);

  makesheet = new MakeSheet();
  makesheet.vcn = 56026;
  makesheet.sequence = sequence;
  makesheet.pay_from = pay_from;
  makesheet.pay_to = pay_to;
  makesheet.scan_count = scan_count;
  makesheet.min_utxo = min_utxo;
  makesheet.max_utxo = max_utxo;
  makesheet.sort_flag = sort_flag;
  // makesheet.from_uocks = from_uocks;
  makesheet.last_uocks = [0];
  return submit_txn_(makesheet, submit);
}

List<int> submit_txn_(msg, submit) {
  final command = 'makesheet';
  final payload = makeSheetpayload(msg);
  final binary = wholePayload(payload, command);
  return binary;
}

Uint8List decode_check(v) {
  // base58();
  Uint8List a = bs58check.base58.decode(v);
  Uint8List ret = a.sublist(0, a.length - 4);
  Uint8List check = a.sublist(a.length - 4);
  var checksum = sha256.convert(sha256.convert(ret).bytes).bytes.sublist(0, 4);
  if (checksum.toString() == check.toString()) {
    return ret;
  } else {
    return null;
  }
}

List<int> CHR(int value) {
  var w = ByteDataWriter();
  w.writeUint8(value);
  return w.toBytes();
}

List<int> get_sig_script(
    List<int> sig_len, List<int> sig, List<int> pubkey_len, List<int> pub_key) {
  // var w = ByteDataWriter();
  // w.write(sig_len);
  // w.write(sig);
  // w.write(pubkey_len);
  // w.write(pub_key);
  // return w.toBytes();
  // rnew
}
