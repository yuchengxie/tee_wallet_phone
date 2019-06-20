import 'package:buffer/buffer.dart';
import 'package:tee_wallet/api/utils.dart';
import 'package:crypto/src/sha256.dart';
import '../model/message.dart';

ByteDataReader _reader;

//bytes转换成一个对象
OrgSheet orgSheetParse(List<int> bytes) {
  _reader = ByteDataReader();
  OrgSheet orgSheet = OrgSheet();
  _reader.add(bytes);
  int sequence = _reader.readUint32();
  orgSheet.sequence = sequence;
  return orgSheet;
}
