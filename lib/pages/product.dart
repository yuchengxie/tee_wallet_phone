import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  ProductPage({Key key}) : super(key: key);

  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text('商品页面'),
          ),
          body: Column(
            children: <Widget>[
              Center(
                  child: Text(
                '这是一个商品页面',
                style: TextStyle(fontSize: 30.0, color: Colors.indigo),
              )),
              RaisedButton(
                child: Text('跳转到商品详情'),
                onPressed: (){
                  Navigator.pushNamed(context, '/productinfo',arguments: {
                    'pid':12345,
                  });
                },
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
              ),
            ],
          )),
    );
  }
}
