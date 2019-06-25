import 'package:flutter/material.dart';
import 'tabs/home.dart';
import 'tabs/settings.dart';
import 'tabs/category.dart';
import 'tabs/personal.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _index = 0;
  List _list = [HomePage(), CategoryPage(), SettingPage(), PersonalPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: Colors.white,
        ),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // print('hh');
            setState(() {
              this._index=1;
            });
          },
          backgroundColor: this._index==1?Colors.red:Colors.yellow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: this._list[this._index],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.red[600],
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            this._index = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('资产')),
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment), title: Text('行情')),
          BottomNavigationBarItem(
            icon: Icon(Icons.find_in_page),
            title: Text('发现'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            title: Text('我'),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: UserAccountsDrawerHeader(
                  accountName: Text('hongzhuanfang'),
                  accountEmail: Text('18823**asdf@google.com'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'http://cdn.duitang.com/uploads/blog/201402/28/20140228230748_VLMv5.thumb.700_0.jpeg'),
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(
                        'https://www.itying.com/images/flutter/1.png'),
                    fit: BoxFit.cover,
                  )),
                  otherAccountsPictures: <Widget>[
                    Image.network('https://www.itying.com/images/flutter/2.png')
                  ],
                  // child: DrawerHeader(
                  //   child: Text('欢迎使用TEE挖矿钱包'),
                  //   decoration: BoxDecoration(
                  //     // color: Colors.yellow
                  //     image: DecorationImage(
                  //       image: NetworkImage('https://www.itying.com/images/flutter/6.png'),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                ))
              ],
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.home),
              ),
              title: Text('我的空间'),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.people),
              ),
              title: Text('用户中心'),
              onTap: () {
                Navigator.pushNamed(context, '/user');
              },
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.settings),
              ),
              title: Text('设置中心'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/set');
              },
            ),
          ],
        ),
      ),
      // endDrawer: Drawer(child: Text('右侧'),),
    );
  }
}
