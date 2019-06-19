import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/wallet.dart';
import 'utils.dart';

const WEB_SERVER_BASE = 'http://127.0.0.1:3000';
const WEB_SERVER_ADDR = 'http://user1-node.nb-chain.net';

void get_wallet() async {
  final url = WEB_SERVER_BASE + '/get_wallet';
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final _json = json.decode(response.body);
    final wallet = Wallet.fromJson(_json);
    print('wallet:${_json}');
  } else {
    throw Exception('fail to load get_wallet');
  }
}

void get_block() async {
  final url = WEB_SERVER_BASE + '/get_block';
  // final response=await http.post(url,body: null);
  final response = await http.post(url);
  print('response body:${response.body}');
}
