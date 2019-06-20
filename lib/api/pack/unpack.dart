import 'package:buffer/buffer.dart';
import '../utils/utils.dart';
import '../../model/message.dart';

ByteDataReader _reader;
//bytes转换成一个对象
OrgSheet orgSheetParse(List<int> bytes) {
  _reader = ByteDataReader();
  _reader.add(bytes);
  int sequence = _reader.readUint32();
  List<VarStrList> pks_out = _readPksout();
  List<int> last_uocks = _readLastUocks();
  int version = _reader.readUint32();
  List<TxIn> tx_in = _readTxIns();
  List<TxOut> tx_out = _readTxOuts();
  int lock_time = _reader.readUint32();
  String signature = _readVarString();

  OrgSheet _orgSheet = OrgSheet(
      sequence: sequence,
      pks_out: pks_out,
      last_uocks: last_uocks,
      version: version,
      tx_in: tx_in,
      tx_out: tx_out,
      lock_time: lock_time,
      signature: signature);
  return _orgSheet;
}

List<TxIn> _readTxIns() {
  List<TxIn> tx_ins = List<TxIn>();
  int len1 = _reader.readUint8();
  for (var i = 0; i < len1; i++) {
    //1.prev_output
    String hash = bytesToHexStr(_reader.read(32));
    int index = _reader.readUint32();
    OutPoint prev_output = OutPoint(hash: hash, index: index);
    //2.sig_script
    String sig_script = _readVarString();
    //3.sequence
    int sequence = _reader.readUint32();
    TxIn txIn = TxIn(
        prev_output: prev_output, sig_script: sig_script, sequence: sequence);
    tx_ins.add(txIn);
  }
  return tx_ins;
}

List<TxOut> _readTxOuts() {
  List<TxOut> tx_outs = List<TxOut>();
  int len1 = _reader.readUint8();
  for (var i = 0; i < len1; i++) {
    int value = _reader.readUint64();
    String pk_script = _readVarString();
    TxOut txOut = TxOut(value: value, pk_script: pk_script);
    tx_outs.add(txOut);
  }
  return tx_outs;
}

String _readVarString() {
  int len = _reader.readUint8();
  if(len==0){
    return '';
  }
  return bytesToHexStr(_reader.read(len));
}

List<int> _readLastUocks() {
  List<int> last_uocks = List<int>();
  int len = _reader.readUint8();
  for (var i = 0; i < len; i++) {
    int v = _reader.readUint64();
    last_uocks.add(v);
  }
  return last_uocks;
}

List<VarStrList> _readPksout() {
  List<VarStrList> pksout = List<VarStrList>();

  int len1 = _reader.readUint8();
  int len2 = _reader.readUint8();
  for (int i = 0; i < len1; i++) {
    VarStrList varlist = VarStrList();
    varlist.items = List<String>();
    for (int i = 0; i < len2; i++) {
      int len3 = _reader.readUint8();
      List<int> item = _reader.read(len3);
      final str = bytesToHexStr(item);
      varlist.items.add(str);
    }
    pksout.add(varlist);
  }
  return pksout;
}
