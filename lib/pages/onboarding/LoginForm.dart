import 'dart:async';
import 'dart:developer';

import 'package:MyE2/pages/classes/globals.dart';
import 'package:MyE2/utils/Endpoints.dart';
import 'package:flutter/material.dart';
import 'package:MyE2/pages/MainTabNavigation.dart';
import 'package:MyE2/pages/models/AppState.dart';
import 'package:MyE2/pages/models/Onboarding.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

void _navigateToHome(context, widget) {
  Timer(
    Duration(milliseconds: 1350),
    () async {
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
    },
  );
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  bool isLoggingIn = false;

  void _loginBtnClicked() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() => {isLoggingIn = true});

    await Onboarding.login(
      widget.appState,
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

        _navigateToHome(context, widget);
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

  void _showDialog(url) {
    slideDialog.showSlideDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.7),
      pillColor: Colors.blue,
      backgroundColor: Colors.white,
      child: Expanded(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: url,
          onPageStarted: (String url) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            try {
              RegExp re = RegExp(
                r'access_token=(.*?)&',
                caseSensitive: false,
              );

              var match = re.firstMatch(url);

              String accessToken = match.group(1);

              re = RegExp(
                r'id_token=(.*?)&',
                caseSensitive: false,
              );

              String idToken = match.group(1);

              re = RegExp(
                r'refresh_token=(.*?)&',
                caseSensitive: false,
              );

              String refreshToken = match.group(1);

              await prefs.setString('refresh_token', refreshToken);
              await prefs.setString('id_token', idToken);
              await prefs.setString('access_token', accessToken);

              Onboarding.finalizeSession(
                widget.appState,
                () {
                  widget.appState.initSettings();

                  setState(() => {isLoggingIn = false});

                  _navigateToHome(context, widget);
                },
              );
            } catch (e) {}
          },
        ),
      ),
    );
  }

  Widget _loginContent() {
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
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Text(
                                  'Or',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              SignInButton(
                                Buttons.Facebook,
                                onPressed: () async {
                                  _showDialog(SOCIAL_LOGIN);
                                },
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

  @override
  Widget build(BuildContext context) {
    return _loginContent();
  }
}
