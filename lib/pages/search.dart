import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final arguments;
  SearchPage({this.arguments});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('搜索')),
      body: Center(
        child: Text('这是我的第一个搜索界面${this.arguments!=null?this.arguments['id']:0}',style: TextStyle(
          fontSize: 27,
          color: Colors.indigo
        ),),
      ),
    );
  }
}
