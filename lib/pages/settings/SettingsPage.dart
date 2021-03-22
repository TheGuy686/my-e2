import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MyE2/pages/Login.dart';
import 'package:MyE2/pages/models/AppState.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:MyE2/pages/models/SettingsModel.dart';
import 'package:MyE2/pages/settings/AboutTheTeam.dart';

class SettingsPage extends StatefulWidget {
  AppState appState;

  SettingsPage({Key key, @required this.appState}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText2;

    final List<Widget> aboutBoxChildren = <Widget>[
      SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: textStyle,
                text: 'My E2 application is an application to help expand '
                    'and support the earth2.io game. This app does not have any official association '
                    'with the earth2.io website and we work independantly. \n\n'
                    'Please help support by using our discount code and consider donating to any of our donation sources. '
                    '\n\nThank you \n\n'),
            TextSpan(
              style: textStyle.copyWith(color: Theme.of(context).accentColor),
              text: 'https://multithreadlabs.io',
            ),
            TextSpan(style: textStyle, text: '.'),
          ],
        ),
      ),
    ];

    return SettingsScreen(
      title: "Application Settings",
      children: [
        SettingsGroup(
          title: 'Account',
          children: <Widget>[
            TextInputSettingsTile(
              title: 'Profile Id',
              settingKey: 'profile-id',
              initialValue: widget.appState.settings['profileId'],
              validator: (String profileId) {
                if (profileId != null && profileId.length > 3) {
                  return null;
                }
                return "Profile Id can't be smaller than 10 letters";
              },
              borderColor: Colors.blueAccent,
              errorColor: Colors.deepOrangeAccent,
              onChange: (String val) {
                widget.appState.settings['profileId'] = val;
                SettingsModel.updateSettings(widget.appState, val);
              },
            ),
          ],
        ),
        SettingsGroup(
          title: 'App',
          children: <Widget>[
            SettingsContainer(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: InkWell(
                        // When the user taps the button, show a snackbar.
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 20),
                          child: Text(
                            'About App',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            // applicationIcon: const FlutterLogo(),
                            applicationName: 'My E2',
                            applicationVersion: 'March 2021',
                            applicationLegalese:
                                '\u{a9} 2021 MultithreadLabs.io',
                            children: aboutBoxChildren,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: InkWell(
                        // When the user taps the button, show a snackbar.
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 20),
                          child: Text(
                            'About the Team',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AboutTheTeamPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () async {
                    await widget.appState.logout();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Login(
                          appState: widget.appState,
                        ),
                      ),
                      ModalRoute.withName('/'),
                    );
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       child: Padding(
        //         padding: EdgeInsets.all(10),
        //         child: ElevatedButton(
        //           style: ButtonStyle(
        //             backgroundColor:
        //                 MaterialStateProperty.all<Color>(Colors.blue),
        //           ),
        //           onPressed: () async {
        //             await Settings.setValue<String>(
        //                 'profile-id', 'f108dd87-0202-41b4-99b6-b075323f68ea');

        //             SettingsModel.updateSettings(
        //               widget.appState,
        //               'f108dd87-0202-41b4-99b6-b075323f68ea',
        //             );
        //           },
        //           child: Text(
        //             'DEV FILLIN',
        //             style: TextStyle(color: Colors.white),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // )
      ],
    );
  }
}
