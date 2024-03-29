import 'package:flutter/material.dart';
import '../../api/server/net.dart';
import '../../api/transfer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('跳转到搜索页面'),
            onPressed: () {
              Navigator.pushNamed(context, '/search', arguments: {
                'id': 555,
              });
            },
            color: Theme.of(context).accentColor,
            textTheme: ButtonTextTheme.primary,
          ),
          RaisedButton(
            child: Text('跳转到商品页面'),
            onPressed: () {
              Navigator.pushNamed(context, '/product');
            },
            color: Theme.of(context).accentColor,
            textTheme: ButtonTextTheme.primary,
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text('获取钱包信息'),
            onPressed: () {
              get_wallet();
            },
            color: Theme.of(context).accentColor,
            textTheme: ButtonTextTheme.primary,
          ),
          RaisedButton(
            child: Text('网络请求: get_block'),
            onPressed: () {
              get_block();
            },
            color: Theme.of(context).accentColor,
            textTheme: ButtonTextTheme.primary,
          ),
          RaisedButton(
            child: Text('发起一笔交易'),
            onPressed: null,
            color: Theme.of(context).accentColor,
            textTheme: ButtonTextTheme.primary,
          ),
          RaisedButton(
            child: Text('按钮测试效果'),
            onPressed: () {
              // query_sheet('', '');
              Navigator.pushNamed(context, '/button');
            },
            color: Theme.of(context).accentColor,
            textTheme: ButtonTextTheme.primary,
          ),
          RaisedButton(
            child: Text('表单组件'),
            onPressed: (){
              Navigator.pushNamed(context, '/textfield');
            },
          )
        ],
      ),
    );
  }
}
