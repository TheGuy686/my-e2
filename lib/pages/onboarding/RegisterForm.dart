import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:MyE2/pages/models/AppState.dart';
import 'package:MyE2/pages/models/Onboarding.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterForm extends StatefulWidget {
  AppState appState;
  dynamic toggelRegister;

  RegisterForm({@required this.appState, this.toggelRegister});

  @override
  _RegisterFormState createState() {
    return _RegisterFormState();
  }
}

final RoundedLoadingButtonController _btnRegisterController =
    new RoundedLoadingButtonController();

class _RegisterFormState extends State<RegisterForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool isRegistering = false;

  String password = '';
  String passwordConfirm = '';

  String _passwordIsvalid(pass) {
    RegExp regExp = new RegExp(
      r"([A-Z]+)",
      caseSensitive: true,
      multiLine: false,
    );

    if (!regExp.hasMatch(pass)) {
      return 'Password doesnt contain a capital "A-Z"';
    }

    regExp = new RegExp(
      r"([a-z]+)",
      caseSensitive: true,
      multiLine: false,
    );

    if (!regExp.hasMatch(pass)) {
      return 'Password doesnt contain none capitals "a-z"';
    }

    regExp = new RegExp(
      r"([0-9]+)",
      caseSensitive: true,
      multiLine: false,
    );

    if (!regExp.hasMatch(pass)) {
      return 'Password doesnt contain any numbers "0-9"';
    }

    regExp = new RegExp(
      r"([\$\#\!\@\%\^\&\*\(\|\)]+)",
      caseSensitive: true,
      multiLine: false,
    );

    if (!regExp.hasMatch(pass)) {
      return 'Password doesnt contain any special chars "!#\$%^*" ...';
    }

    return '';
  }

  _renderPassError() {
    String error = _passwordIsvalid(widget.appState.password);

    if (error == '') return Container();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.white.withOpacity(0.8),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Text(
          error,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Build a Form widget using the _formKey created above.
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
                                    return 'Please enter a username';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter a username',
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
                                    print(text);
                                    widget.appState.username = text;
                                  });
                                },
                                // initialValue: widget.appState.username,
                                initialValue: 'gigx',
                              ),
                              SizedBox(height: 20),
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
                                    print(text);
                                    widget.appState.email = text;
                                  });
                                },
                                // initialValue: widget.appState.email,
                                initialValue: 'gingzginger@gmail.com',
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
                                  _passwordIsvalid(text);

                                  setState(() {
                                    widget.appState.password = text;
                                  });
                                },
                                initialValue: '',
                              ),
                              SizedBox(height: 5),
                              _renderPassError(),
                              SizedBox(height: 20),
                              TextFormField(
                                obscureText: true,
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Passwords don\'t match';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
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
                                    passwordConfirm = text;
                                  });
                                },
                                initialValue: '',
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
                                      'Login',
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
                                        'Sign Up',
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      borderRadius: 2,
                                      elevation: 4,
                                      color: Colors.white,
                                      valueColor: !isRegistering
                                          ? Colors.white
                                          : Colors.blue,
                                      width: 75,
                                      height: 37,
                                      successColor: Colors.green,
                                      controller: _btnRegisterController,
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();

                                        print(passwordConfirm +
                                            ' : ' +
                                            widget.appState.password);

                                        // if (passwordConfirm !=
                                        //     widget.appState.password) {
                                        //   ScaffoldMessenger.of(context)
                                        //       .showSnackBar(
                                        //     SnackBar(
                                        //       backgroundColor: Colors.red,
                                        //       content: Text(
                                        //         'Error: passwords did not match',
                                        //         style: TextStyle(
                                        //           color: Colors.white,
                                        //           fontWeight: FontWeight.w600,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   );

                                        //   return;
                                        // }

                                        if (!_formKey.currentState.validate()) {
                                          return;
                                        }

                                        setState(() => {isRegistering = true});

                                        await Onboarding.register(
                                          widget.appState.email,
                                          widget.appState.username,
                                          widget.appState.password,
                                          () {
                                            setState(
                                                () => {isRegistering = false});
                                            _btnRegisterController.success();

                                            Timer(
                                              Duration(milliseconds: 800),
                                              () {
                                                _btnRegisterController.reset();

                                                widget.toggelRegister();
                                              },
                                            );

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                  'User successfully registered. Please verify your email',
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
                                                _btnRegisterController.reset();
                                              },
                                            );
                                          },
                                          (String error) {
                                            setState(
                                                () => {isRegistering = false});
                                            _btnRegisterController.error();

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
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
                                                _btnRegisterController.reset();
                                              },
                                            );
                                          },
                                        );
                                      },
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
