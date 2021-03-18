import 'package:flutter/material.dart';
import 'package:my_e2/pages/onboarding/LoginForm.dart';

import 'onboarding/RegisterForm.dart';

class Login extends StatefulWidget {
  bool showRegister = false;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    double bgOpacity = 0.45;

    toggelRegister() {
      setState(() {
        widget.showRegister = !widget.showRegister;
      });
    }

    _renderForm() {
      if (widget.showRegister)
        return RegisterForm(toggelRegister: toggelRegister);

      return LoginForm(toggelRegister: toggelRegister);
    }

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
              _renderForm(),
            ],
          ),
        ),
      ),
    );
  }
}
