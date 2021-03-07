// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
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

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));

    double bgOpacity = 0.45;

    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.blue,
          width: double.infinity,
          height: screenHeight - statusBarHeight,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: -(screenWidth * 1.05),
                top: -(screenWidth),
                child: Transform.rotate(
                  angle: 158.9,
                  child: Opacity(
                    opacity: bgOpacity,
                    child: Image(
                      image: AssetImage('lib/assets/earth2.png'),
                      width: 1000,
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Image(
                        image: AssetImage('lib/assets/my-e2.png'),
                        width: 100,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: -(screenWidth / 5),
                top: (screenHeight * 0.25),
                child: Transform.rotate(
                  angle: 25.2,
                  child: Opacity(
                    opacity: bgOpacity,
                    child: Image(
                      image: AssetImage('lib/assets/earth2.png'),
                      width: 1000,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
