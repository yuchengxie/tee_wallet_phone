import 'dart:ui';

import 'package:flutter/material.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('按钮演示'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,color: Colors.black,size: 40,),
          backgroundColor: Colors.yellow,
          onPressed: (){
            print('floatingActionButton');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.white,
                  textColor: Colors.blue,
                  // elevation: 20,
                  child: Text('按钮1'),
                  onPressed: () {},
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 400,
                  child: RaisedButton(
                    child: Text('调整高宽'),
                    textColor: Colors.white,
                    color: Colors.blue,
                    elevation: 20,
                    onPressed: () {},
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      child: Text('按钮'),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: RaisedButton.icon(
                      icon: Icon(Icons.home),
                      label: Text('图标'),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  child: RaisedButton(
                    color: Colors.cyan,
                    child: Text('形状'),
                    textColor: Colors.white,
                    elevation: 10,
                    // shape: CircleBorder(
                    //     side: BorderSide(
                    //         color: Colors.orange,
                    //         width: 1.0,
                    //         style: BorderStyle.none)),
                    shape: RoundedRectangleBorder(
                      // side: BorderSide(
                      //   width: 2,
                      //   style: BorderStyle.none,

                      // )
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {},
                    splashColor: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                  child: Text('扁平化按钮'),
                  color: Colors.blue,
                  onPressed: () {},
                ),
                SizedBox(
                  width: 10,
                ),
                OutlineButton(
                  child: Text('线框按钮'),
                  onPressed: () {},
                  // color: Colors.orange,
                  textColor: Colors.green,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                  height: 40,
                  margin: EdgeInsets.all(10),
                  child: OutlineButton(
                    color: Colors.orange,
                    // textColor: Colors.white,
                    child: Text('注册'),
                    onPressed: () {},
                  ),
                ))
              ],
            ),
            Row(
              children: <Widget>[
                MyButton(
                  text: '我的按钮哦',
                  height: 40,
                  width: 130,
                  pressed: (){},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

//自定义组件
class MyButton extends StatelessWidget {
  final text;
  final pressed;
  final double height;
  final double width;
  const MyButton(
      {Key key,
      this.text = '自定义按钮',
      this.pressed = null,
      this.height = 80,
      this.width = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      child: RaisedButton(child: Text(this.text), onPressed: this.pressed),
    );
  }
}
