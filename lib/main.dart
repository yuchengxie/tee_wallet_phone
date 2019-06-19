import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'routes.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: Tabs(),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute
      // routes: {
      //   '/form': (context, {arguments}) => FormPage(),
      //   '/search': (context, {arguments}) => SearchPage(arguments: arguments)
      // },
      // onGenerateRoute: (RouteSettings settings){
      //   print('123');
      // },
      // onGenerateRoute: (RouteSettings settings) {
      //   print('123');
        // final String name = settings.name;
        // final Function pageControlBuilder = this.routes[name];
        // print(settings.name);
        // if (pageControlBuilder != null) {
        //   if (settings.arguments != null) {
        //     final Route route = MaterialPageRoute(
        //         builder: (context) =>
        //             pageControlBuilder(context, arguments: settings.arguments)
        //         );
        //     return route;
        //   }
        // }
      // },
    );
  }
}

// class HomePage extends StatefulWidget {
//   HomePage({Key key}) : super(key: key);

//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int countNum = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         SizedBox(
//           height: 200,
//         ),
//         Chip(
//           label: Text('${this.countNum}'),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         RaisedButton(
//           child: Text('按钮'),
//           onPressed: () {
//             setState(() {
//               this.countNum++;
//             });
//           },
//         )
//       ],
//     );
//   }
// }

// class LayoutDemo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Center(
//       child: Container(
//         height: 400,
//         width: 300,
//         color: Colors.red,
//         child: Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             Positioned(
//               left: 10,
//               child: Icon(
//                 Icons.home,
//                 size: 30,
//                 color: Colors.white,
//               ),
//             ),
//             Positioned(
//               bottom: 0,

//               child: Icon(
//                 Icons.search,
//                 size: 60,
//                 color: Colors.white,
//               ),
//             ),
//             Positioned(
//               top: 30,
//               child: Icon(
//                 Icons.settings_applications,
//                 size: 60,
//                 color: Colors.white,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class LayoutDemo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Column(
//       children: <Widget>[
//         // Container(
//         //   height: 200,
//         //   color: Colors.black,
//         //   child: Text('你好flutter'),
//         // ),
//         Row(
//           children: <Widget>[
//             Expanded(
//               child: Container(
//                 height: 180,
//                 color: Colors.lightBlue[300],
//                 child: Text('你好flutter'),
//               ),
//             )
//           ],
//         ),
//         SizedBox(height: 10,),
//         Row(
//           children: <Widget>[
//             Expanded(
//                 flex: 2,
//                 child: Container(
//                   height: 200,
//                   child: Image.network(
//                     'https://www.itying.com/images/flutter/1.png',
//                     fit: BoxFit.cover,
//                   ),
//                 )),
//             // SizedBox(width: 10,),
//             Expanded(
//                 flex: 1,
//                 child: Container(
//                     height: 200,
//                     child: ListView(
//                       children: <Widget>[
//                         Container(
//                           height: 95,
//                           child: Image.network(
//                               'https://www.itying.com/images/flutter/2.png'),
//                         ),
//                         SizedBox(height: 10,),
//                         Container(
//                           height: 95,
//                           child: Image.network(
//                               'https://www.itying.com/images/flutter/3.png'),
//                         )
//                       ],
//                     )))
//           ],
//         )
//       ],
//     );
//   }
// }
