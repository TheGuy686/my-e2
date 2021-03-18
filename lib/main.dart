import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_e2/pages/SplashScreen.dart';

void main() => runApp(MyRootApp());

class MyRootApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'MyE2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}
