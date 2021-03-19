import 'package:flutter/material.dart';
import 'package:my_e2/pages/youtube-channel/OfficialChannel.dart';

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

  List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    OfficialChannel(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.youtube_searched_for_rounded),
            label: 'Youtube',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
