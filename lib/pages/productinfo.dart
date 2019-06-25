import 'package:flutter/material.dart';

class ProductInfoPage extends StatefulWidget {
  final Map arguments;
  ProductInfoPage({Key key, this.arguments}) : super(key: key);

  _ProductInfoPageState createState() =>
      _ProductInfoPageState(arguments: arguments);
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  Map arguments;
  _ProductInfoPageState({this.arguments});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('详情'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
                '这是一个商品详情界面,id为${this.arguments['pid'] != null ? this.arguments['pid'] : 0}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ));
  }
}
