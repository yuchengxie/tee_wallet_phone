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
    );
  }
}
