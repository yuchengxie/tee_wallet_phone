import 'package:buffer/buffer.dart';
import 'package:tee_wallet/api/utils.dart';
import 'package:crypto/src/sha256.dart';
import '../model/message.dart';

void main() {
  makeSheetBinary([], 'makesheet');
}

ByteDataWriter _write;
final _magic = [0xf9, 0x6e, 0x62, 0x74];

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
