import 'dart:convert';

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
  @override
  String toString() {
    print('this:$this');
    return jsonEncode(this);
  }
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
