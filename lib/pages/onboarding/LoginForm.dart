import 'dart:async';
import 'dart:developer';

import 'package:MyE2/pages/classes/globals.dart';
import 'package:flutter/material.dart';
import 'package:MyE2/main.dart';
import 'package:MyE2/pages/MainTabNavigation.dart';
import 'package:MyE2/pages/models/AppState.dart';
import 'package:MyE2/pages/models/Onboarding.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginForm extends StatefulWidget {
  AppState appState;
  dynamic toggelRegister;

  LoginForm({@required this.appState, this.toggelRegister});

  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }
}

final RoundedLoadingButtonController _btnLoginController =
    new RoundedLoadingButtonController();

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  bool isLoggingIn = false;

  void _loginBtnClicked() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() => {isLoggingIn = true});

    inspect(widget.appState);

    await Onboarding.login(
      widget.appState.email,
      widget.appState.password,
      () {
        widget.appState.initSettings();

        setState(() => {isLoggingIn = false});
        _btnLoginController.success();

        Timer(
          Duration(milliseconds: 800),
          () {
            _btnLoginController.reset();
          },
        );

        Timer(Duration(milliseconds: 1350), () async {
          _btnLoginController.reset();

          await widget.appState.initSettings();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MainTabNavigation(
                appState: widget.appState,
              ),
            ),
          );
        });
      },
      (String error) {
        setState(() => {isLoggingIn = false});
        _btnLoginController.error();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Error: $error',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

        Timer(
          Duration(seconds: 2),
          () {
            _btnLoginController.reset();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      primary: true,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            height: screenHeight * 0.9,
            child: Center(
              child: IntrinsicHeight(
                child: Container(
                  width: screenWidth * 0.8,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 4,
                          child: Image(
                            image: AssetImage('lib/assets/my-e2.png'),
                            width: 100,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter an email',
                                  hintStyle: TextStyle(fontSize: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(16),
                                  fillColor: Colors.white,
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    widget.appState.email = text;
                                  });
                                },
                                initialValue: widget.appState.email,
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                obscureText: true,
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter a password',
                                  hintStyle: TextStyle(fontSize: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(16),
                                  fillColor: Colors.white,
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    widget.appState.password = text;
                                  });
                                },
                                initialValue: (() {
                                  return widget.appState.password;
                                })(),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Spacer(
                                    flex: 12,
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                    onPressed: () {
                                      widget.toggelRegister();
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  SizedBox(
                                    width: 70,
                                    child: RoundedLoadingButton(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      borderRadius: 2,
                                      elevation: 4,
                                      color: Colors.white,
                                      valueColor: !isLoggingIn
                                          ? Colors.white
                                          : Colors.blue,
                                      width: 75,
                                      height: 37,
                                      successColor: Colors.green,
                                      controller: _btnLoginController,
                                      onPressed: _loginBtnClicked,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
