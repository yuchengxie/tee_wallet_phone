import 'package:flutter/material.dart';
import 'package:tee_wallet/pages/buttonpage.dart';
import 'package:tee_wallet/pages/tabs/settings.dart';
import 'package:tee_wallet/pages/user.dart';
import 'pages/form.dart';
import 'pages/mtextfield.dart';
import 'pages/product.dart';
import 'pages/productinfo.dart';
import 'pages/search.dart';
import 'pages/tabs.dart';

//配置路由
final routes = {
  '/': (context) => Tabs(),
  '/product': (context) => ProductPage(),
  '/productinfo': (context,{arguments}) => ProductInfoPage(arguments: arguments),
  '/form': (context) => FormPage(),
  '/search': (context, {arguments}) => SearchPage(arguments: arguments),
  '/user':(context)=>UserPage(),
  '/set':(context)=>SettingPage(),
  '/button':(context)=>ButtonPage(),
  '/textfield':(context,{arguments})=>TextFieldPage()
};

var onGenerateRoute = (RouteSettings settings) {
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  print(name);
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
