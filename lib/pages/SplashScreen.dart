// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.red;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 5;

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: 5);

    //return Timer (_duration, navigationPage);
  }

  void navigationPage() {
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder: (BuildContext context) => AfterSplash()));
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));

    return Scaffold(
        body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                color: Colors.blue,
                width: double.infinity,
                height: MediaQuery.of(context).size.height - statusBarHeight,
                child: Stack(children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.red,
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    color: Colors.green,
                  ),
                ]))));
  }
}
