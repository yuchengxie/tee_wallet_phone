import 'dart:convert';

import 'package:buffer/buffer.dart';
import 'package:tee_wallet/api/utils.dart';
// import 'package:bitcoin_flutter/bitcoin_flutter.dart';
// import 'package:crypto/crypto.dart';
import 'package:crypto/src/sha256.dart';

void main() {
  makeSheetBinary([], 'makesheet');
}

ByteDataWriter _write;
final _magic = [0xf9, 0x6e, 0x62, 0x74];

//bytes转换成一个对象
OrgSheet orgSheetParse(List<int> bytes) {
  return null;
}

List<int> getPayload(List<int> data) {
  if (data.sublist(0, 4).toString() != _magic.toString()) {
    print('data error');
    return null;
  }
  final payload = data.sublist(24);
  final checksum = sha256.convert(sha256.convert(payload).bytes).bytes.sublist(0,4);
  if (data.sublist(20, 24).toString() != checksum.toString()) {
    print('checksum error');
    return null;
  }
  return payload;
}

List<int> makeSheetBinary(List<int> payload, String command) {
  ByteDataWriter w = ByteDataWriter();
  //0-4 magic
  w.write(_magic);
  //4-16
  final _command = strToBytes(command, length: 12);
  w.write(_command);
  //16-20
  w.writeUint32(payload.length);
  //20-24
  final checksum =
      sha256.convert(sha256.convert(payload).bytes).bytes.sublist(0, 4);
  w.write(checksum);
  w.write(payload);
  return w.toBytes();
}

List<int> makeSheetpayload(MakeSheet msg) {
  _write = ByteDataWriter();
  _write.writeUint16(msg.vcn);
  _write.writeUint32(msg.sequence);
  _writepayfrom(msg.pay_from);
  _writepayto(msg.pay_to);
  _write.writeUint16(msg.scan_count);
  _write.writeUint64(msg.min_utxo);
  _write.writeUint64(msg.max_utxo);
  _write.writeUint32(msg.sort_flag);
  _writelastuocks(msg.last_uocks);
  return _write.toBytes();
}

void _writelastuocks(List<int> msg) {
  _write.writeUint8(msg.length);
  for (var i = 0; i < msg.length; i++) {
    _write.writeUint64(msg[i]);
  }
}

void _writepayfrom(List<PayFrom> msg) {
  int len = msg.length;
  _write.writeUint8(len);
  for (int i = 0; i < len; i++) {
    PayFrom p = msg[i];
    String address = p.address;
    _write.writeUint64(p.value);
    _write.writeUint8(address.length);
    _write.write(strToBytes(address));
  }
}

void _writepayto(List<PayTo> msg) {
  int len = msg.length;
  _write.writeUint8(len);
  for (int i = 0; i < len; i++) {
    PayTo p = msg[i];
    String address = p.address;
    _write.writeUint64(p.value);
    _write.writeUint8(address.length);
    _write.write(strToBytes(address));
  }
}

class PayFrom {
  var value;
  var address;
  PayFrom({this.value, this.address});
}

class PayTo {
  var value;
  var address;
  PayTo({this.value, this.address});
}

class MakeSheet {
  int vcn;
  int sequence;
  List<PayFrom> pay_from;
  List<PayTo> pay_to;
  int scan_count;
  int min_utxo;
  int max_utxo;
  int sort_flag;
  List<int> last_uocks;
  MakeSheet(
      {this.vcn,
      this.sequence,
      this.pay_from,
      this.pay_to,
      this.scan_count,
      this.min_utxo,
      this.max_utxo,
      this.sort_flag,
      this.last_uocks});
}

class OrgSheet {
  int sequence;
  List<List<String>> pks_out;
  List<int> last_uocks;
  int version;
  List<TxIn> tx_in;
  List<TxOut> tx_out;
  int lock_time;
  String signature;
  OrgSheet(
      {this.sequence,
      this.pks_out,
      this.last_uocks,
      this.version,
      this.tx_in,
      this.tx_out,
      this.lock_time,
      this.signature});
}

class OutPoint {
  List<int> hash;
  int index;
  OutPoint({this.hash, this.index});
}

class TxIn {
  OutPoint prev_output;
  String sig_script;
  int sequence;
  TxIn({this.prev_output, this.sig_script, this.sequence});
}

class TxOut {
  int value;
  String pk_script;
  TxOut({this.value, this.pk_script});
}
