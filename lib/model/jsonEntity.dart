class TeeWallet {
  final String pub_key;
  final String pub_hash;
  final int vcn;
  final String coin_type;
  final String pub_addr;
  final String pin_code;

  TeeWallet(this.pub_key, this.pub_hash, this.vcn, this.coin_type,
      this.pub_addr, this.pin_code);

  TeeWallet.fromJson(Map<String, dynamic> json)
      : pub_key = json['pub_key'],
        pub_hash = json['pub_hash'],
        vcn = json['vcn'],
        coin_type = json['coin_type'],
        pub_addr = json['pub_addr'],
        pin_code = json['pin_code'];
}

class TeeSign {
  String msg;
  int status;
  TeeSign({this.msg, this.status});
  TeeSign.fromJson(Map<String, dynamic> json)
      : msg = json['msg'],
        status = json['status'];
}
