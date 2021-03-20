import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'package:MyE2/pages/youtube-channel/OfficialChannel.dart';

import 'dashboard/Dashbaord.dart';
import 'models/AppState.dart';

class MainTabNavigation extends StatefulWidget {
  AppState appState;

  MainTabNavigation({Key key, @required this.appState}) : super(key: key);

  @override
  _MainTabNavigationState createState() => _MainTabNavigationState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MainTabNavigationState extends State<MainTabNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions() {
    return [
      Dashboard(appState: widget.appState),
      OfficialChannel(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _widgetOptions().elementAt(_selectedIndex),
      ),
      bottomNavigationBar: MotionTabBar(
        labels: ["Dashboard", "Youtube"],
        initialSelectedTab: "Dashboard",
        tabIconColor: Colors.grey,
        tabSelectedColor: Colors.blue,
        onTabItemSelected: _onItemTapped,
        icons: [Icons.account_box, Icons.play_circle_fill_rounded],
        textStyle: TextStyle(color: Colors.blue),
      ),
    );
  }
}
