import 'package:flutter/material.dart';

class FormPage extends StatelessWidget {
  String title;
  FormPage({this.title='表单'});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('返回'),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
      appBar: AppBar(title: Text(this.title)),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('我是一个表单页面'),
          ),
          ListTile(
            title: Text('我是一个表单页面'),
          ),
          ListTile(
            title: Text('我是一个表单页面'),
          ),
          ListTile(
            title: Text('我是一个表单页面'),
          ),
        ],
      ),
    );
  }
}

// class FormPage extends StatefulWidget {
//   FormPage({Key key}) : super(key: key);
//   _FormPageState createState() => _FormPageState();
// }

// class _FormPageState extends State<FormPage> {
//   String title;
//   _FormPageState({this.title:'表单111'});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(this.title)),
//       body: ListView(
//         children: <Widget>[
//           ListTile(
//             title: Text('我是一个表单页面'),
//           ),
//           ListTile(
//             title: Text('我是一个表单页面'),
//           ),
//           ListTile(
//             title: Text('我是一个表单页面'),
//           ),
//           ListTile(
//             title: Text('我是一个表单页面'),
//           ),
//         ],
//       ),
//     );
//   }
// }
