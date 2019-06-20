import './utils.dart';
import 'package:buffer/buffer.dart';

var opcode;
var value;
var verify;
var bytes_;
var OP_LITERAL = 0x1ff;
var _expand_verify;

void process(String pk_script) {
  var _tokens = [];
  var script = hexStrToBytes(pk_script);
  while (script.length > 0) {
    // opcode=
  }
}

int ORD(ch) {
  // return bh.bufToNumer(ch);
  
}
