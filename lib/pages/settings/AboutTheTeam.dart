import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_e2/pages/models/AppState.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AboutTheTeamPage extends StatefulWidget {
  @override
  _AboutTheTeamPageState createState() => _AboutTheTeamPageState();
}

class _AboutTheTeamPageState extends State<AboutTheTeamPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About the Tean'),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Text('About the Team'),
        ],
      ),
    );
  }
}
