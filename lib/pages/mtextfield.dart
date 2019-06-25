import 'package:flutter/material.dart';

class TextFieldPage extends StatefulWidget {
  final Map arguments;
  TextFieldPage({Key key, this.arguments}) : super(key: key);

  _TextFieldPageState createState() =>
      _TextFieldPageState(arguments: arguments);
}

class _TextFieldPageState extends State<TextFieldPage> {
  final Map arguments;

  var _username = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _username.text = 'hzf';
  }

  _TextFieldPageState({this.arguments});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('表单组件'),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: '请输入用户名',
                ),
                controller: _username,
                onChanged: (value) {
                  setState(() {
                    _username.text = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 40,
                child: RaisedButton(
                  child: Text('登陆'),
                  onPressed: () {
                    print(_username.text);
                  },
                  textColor: Colors.white,
                  color: Colors.blue,
                ),
              ),
            ],
          )),
    );
  }
}

class TextDemo extends StatelessWidget {
  const TextDemo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: '请输入内容',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: '多行文本',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: '输入密码', border: OutlineInputBorder())),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: '请输入用户名'),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: '请输入密码'),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration:
                InputDecoration(icon: Icon(Icons.people), hintText: '请输入密码'),
          )
        ],
      ),
    );
  }
}
