import 'package:flutter/material.dart';
import '../form.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text('跳转到表单页面并传值'),
          onPressed: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => FormPage(title: '这是表单😯',)));
            Navigator.pushNamed(context, '/form');
          },
          color: Theme.of(context).accentColor,
          textTheme: ButtonTextTheme.primary,
        )
      ],
    );
  }
}
