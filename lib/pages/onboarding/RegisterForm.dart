import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_e2/pages/models/AppState.dart';
import 'package:my_e2/pages/models/Onboarding.dart';
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    bool isRegistering = false;

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
                                    return 'Please enter an email or username';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter an email or username',
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
                                initialValue: 'ryanjcooke@hotmail.com',
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
                                initialValue: 'Luvmajesus1!*',
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                obscureText: true,
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Confirm Password';
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
                                    widget.appState.password = text;
                                  });
                                },
                                initialValue: 'Luvmajesus1!*',
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

                                        if (!_formKey.currentState.validate()) {
                                          return;
                                        }

                                        setState(() => {isRegistering = true});

                                        await Onboarding.register(
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
                                              },
                                            );

                                            Timer(Duration(milliseconds: 1350),
                                                () {
                                              _btnRegisterController.reset();
                                            });
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
