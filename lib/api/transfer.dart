import 'dart:convert';
import 'dart:io';
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
// _wait_submit = [],
    SHEET_CACHE_SIZE = 16,
    sn,
    tx_ins2 = [],
    tx_ins_len,
    pks_out0,
// hash_type = 1,
    submit = true;
List _wait_submit = [];
int seq = 0;
List state_info;
TeeWallet _wallet;
final magic = [0xf9, 0x6e, 0x62, 0x74];
MakeSheet makesheet;
OrgSheet orgSheet;
List<int> hash_;

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
  makesheet = prepare_txn1_(pay_to, ext_in, submit, scan_count, min_utxo,
      max_utxo, sort_flag, from_uocks);
  if (makesheet == null) {
    sn = 0;
    return;
  }

  String command = 'makesheet';
  List<int> payload_makesheet = makeSheetpayload(makesheet);
  List<int> bytes_makesheet = wholePayload(payload_makesheet, command);

  String s1 = bytesToHexStr(bytes_makesheet);
  print('1准备发送数据:${s1}--${s1.length}');
  final url_sheet = WEB_SERVER_ADDR + '/txn/sheets/sheet';
  final response_sheet = await http.post(url_sheet, body: bytes_makesheet);
  if (response_sheet.statusCode != 200) {
    print('err /txn/sheets/sheet');
    return;
  }
  List<int> orgsheet_bytes = response_sheet.bodyBytes;
  String s = bytesToHexStr(orgsheet_bytes);
  print('1接收到数据${s}---${s.length}');
// List<int> orgsheet_payload = getPayload(orgsheet_bytes);
// //test
// if (orgsheet_payload == null) {
//   return;
// }
  String s2 = bytesToHexStr(orgsheet_bytes);
  print('${s2}---${s2.length}');
  orgSheet = parseOrgSheet(orgsheet_bytes);
  if (orgSheet == null) {
    return;
  }
//网络获取钱包
  final url2 = 'http://127.0.0.1:3000/get_wallet';
  final response2 = await http.get(url2);
  if (response2.statusCode != 200) {
    print('server not found');
    return;
  }
  final _json = json.decode(response2.body);
  if (_json['status'] == -1) {
    print('tee not found');
    return;
  }
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
      //tee签名
      final url_sign = 'http://127.0.0.1:3000/get_sign';
      final sign_params = {'payload': s, 'pincode': '000000'};
      final response_sign = await http.post(url_sign, body: sign_params);
      if (response_sign.statusCode != 200) {
        print('sign err');
        return;
      }
      final _json_sign = json.decode(response_sign.body);
      TeeSign teeSign = TeeSign.fromJson(_json_sign);
      print('>>> tee_sign:${teeSign.msg}');

      //验证签名是否合法
      final url_verify_sign = 'http://127.0.0.1:3000/verify_sign';
      final verify_sign_params = {'data': s, 'sig': teeSign.msg};
      final response_verify_sign =
          await http.post(url_verify_sign, body: verify_sign_params);
      if (response_verify_sign.statusCode == 200) {
        final verify_sign_result = json.decode(response_verify_sign.body);
        TeeVerifySign teeVerifySign =
            TeeVerifySign.fromJson(verify_sign_result);
        if (teeVerifySign.status == 0) {
          print('verify sign failed');
          return;
        }else if(teeVerifySign.status==1){
          print('verify sign success');
        }
      }

      List<int> sig = new List<int>.from(hexStrToBytes(teeSign.msg))
        ..addAll(CHR(hash_type));
      print('>>> sig:${bytesToHexStr(sig)}');

      List<int> sig_script = List.from(CHR(sig.length))
        ..addAll(sig)
        ..addAll(CHR(hexStrToBytes(_wallet.pub_key).length))
        ..addAll(hexStrToBytes(_wallet.pub_key));
      print(
          '>>> sig_script:${bytesToHexStr(sig_script)}---${bytesToHexStr(sig_script).length}');
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
  txn_payload = wholePayload(txn_payload, txn.command);
  var t = bytesToHexStr(txn_payload);
  print('txn_payload:${t} --- ${t.length}');
  hash_ = sha256
      .convert(
          sha256.convert(txn_payload.sublist(24, txn_payload.length - 1)).bytes)
      .bytes;
  print('>>> hash_:${bytesToHexStr(hash_)}');
  state_info = [
    orgSheet.sequence,
    txn,
    'requested',
    hash_,
    orgSheet.last_uocks
  ];
  _wait_submit.add(state_info);
  while (_wait_submit.length > SHEET_CACHE_SIZE) {
    _wait_submit.remove(_wait_submit[0]);
  }

  if (submit) {
    int unsign_num = orgSheet.tx_in.length - pks_num;
    if (unsign_num != 0) {
      print('Warning: some input not signed: ${unsign_num}');
      return;
    } else {
      String url_txn = WEB_SERVER_ADDR + '/txn/sheets/txn';
      var response_txn = await http.post(url_txn, body: txn_payload);
      if (response_txn.statusCode != 200) {
        print('error /txn/sheets/txn');
        return;
      }
      List<int> response_txn_bytes = response_txn.bodyBytes;
      String s_txn = bytesToHexStr(response_txn_bytes);
      print('发送txn_payload接收到数据${s_txn}---${s_txn.length}');
      String txn_hash = getTxnHash(response_txn_bytes);

      if (txn_hash != '') {
        int count = 0;
        while (count < 1000) {
          count++;
          sleep(Duration(seconds: 10));
          String url_txnhash =
              WEB_SERVER_ADDR + '/txn/sheets/state?hash=' + txn_hash;
          var response_txnhash = await http.get(url_txnhash);
          if (response_txnhash.statusCode == 200) {
            query_tran(response_txnhash);
          } else {
            print('Error: request failed, code=${response_txnhash.statusCode}');
          }
        }
      }
    }
  }
}

void query_tran(http.Response res) {
  String command = getCommandStrFromBytes(res.bodyBytes);
  if (command == UdpReject.command) {
    UdpReject reject = parseUdpReject(res.bodyBytes);
    if (reject == null) {
      return;
    }
    String sErr = reject.message;
    if (sErr == 'in pending state') {
      // return 'pending';
      print('[${DateTime.now()}] Transaction state: pending');
    } else {
      print('Error:${sErr}');
    }
  } else if (command == UdpConfirm.command) {
    UdpConfirm confirm = parseUdpConfirm(res.bodyBytes);
    if (confirm.hash == bytesToHexStr(hash_)) {
      var hi = confirm.arg & 0xffffffff;
      var num = (confirm.arg >> 32) & 0xffff;
      var idx = (confirm.arg >> 48) & 0xffff;
      print(
          '[${DateTime.now()}] Transaction state: confirm=${num},hi=${hi},idx=${idx}');
    }
  }
}

String getTxnHash(response_txn_bytes) {
  String command = getCommandStrFromBytes(response_txn_bytes);
// List<int> txn_response_payload = response_txn_bytes.sublist(24);
  if (command == UdpReject.command) {
    UdpReject msg3 = parseUdpReject(response_txn_bytes);
    print('Error:${msg3.message}');
  } else if (command == UdpConfirm.command) {
    UdpConfirm msg3 = parseUdpConfirm(response_txn_bytes);
    if (msg3.hash == bytesToHexStr(hash_)) {
      state_info[2] = 'submited';
      sn = orgSheet.sequence;
      // if (sn！=null) {
      List info = submit_info(sn);
      var state = info[2];
      var txn_hash = bytesToHexStr(info[3]);
      String last_uocks = bytesToHexStr(info[4][0]);
      // String last_uocks = info[4][0];
      if (state == 'submited' && txn_hash != null) {
        String sDesc = '\nTransaction state:' + state;
        if (last_uocks != '') {
          sDesc += ',last uock: ' + last_uocks;
          print(sDesc);
          print('[${DateTime.now()}] Transaction hash:${txn_hash}');
        }
        // }
        return txn_hash;
      }
    }
  }
}

List submit_info(sn) {
// var state_info = [orgsheetMsg.sequence, txn, 'requested', hash_, orgsheetMsg.last_uocks];
  for (var i = 0; i < _wait_submit.length; i++) {
    List info = _wait_submit[i];
    if (info[0] == sn) {
      return info;
    }
  }
}

// void waitSubmit(List<int> bytes) {}

MakeSheet prepare_txn1_(pay_to, ext_in, submit, scan_count, min_utxo, max_utxo,
    sort_flag, from_uocks) {
  sequence += 1;
  List<PayFrom> pay_from = List<PayFrom>();
  PayFrom pay_from1 = PayFrom(
    value: 0,
    address: '13TtvKn5cwNhdxfXSbz1MewRnTEPB534rudq41LnRP1T9A4TJmjAKhJ',
  );
  pay_from.add(pay_from1);

  List<PayTo> pay_to = List<PayTo>();
  PayTo pay_to1 = PayTo(
    value: 100000000,
    address: '1118hfRMRrJMgSCoV9ztyPcjcgcMZ1zThvqRDLUw3xCYkZwwTAbJ5o',
  );
  pay_to.add(pay_to1);

  MakeSheet sheet = MakeSheet(
      vcn: 56026,
      sequence: sequence,
      pay_from: pay_from,
      pay_to: pay_to,
      scan_count: scan_count,
      min_utxo: min_utxo,
      max_utxo: max_utxo,
      sort_flag: sort_flag,
      last_uocks: [0]);
// makesheet.vcn = 56026;
// makesheet.sequence = sequence;
// makesheet.pay_from = pay_from;
// makesheet.pay_to = pay_to;
// makesheet.scan_count = scan_count;
// makesheet.min_utxo = min_utxo;
// makesheet.max_utxo = max_utxo;
// makesheet.sort_flag = sort_flag;
// // makesheet.from_uocks = from_uocks;
// makesheet.last_uocks = [0];

  return sheet;
// return submit_txn_(makesheet, submit);
}

int submit_txn_(msg, submit) {
  return 0;
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

// String get_reject_msg_(UdpReject msg){

//     var sErr = msg.message;
//     return sErr or 'Meet unknown error'
// }
