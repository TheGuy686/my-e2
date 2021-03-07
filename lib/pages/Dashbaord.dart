import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future fetchProfile() async {
  try {
    final response =
        await http.get(Uri.https('28a51d8e96f7.ap.ngrok.io', '/get-profile'));

    debugPrint('                                       ');
    debugPrint('                                       ');
    debugPrint('                                       ');
    debugPrint('                                       ');

    debugPrint('FROM JSON: ');

    inspect(jsonDecode(response.body));

    debugPrint('                                       ');
    debugPrint('                                       ');
    debugPrint('                                       ');
    debugPrint('                                       ');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Profile.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  } catch (e) {
    inspect(e);
    //return Profile.fromJson(jsonDecode(response.body));
  }
}

class Profile {
  final int userId;
  final int id;
  final String title;

  Profile({this.userId, this.id, this.title});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future futureProfile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashbaord'),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          futureProfile = fetchProfile();
        },
        child: Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: Center(
          child: Text(
            'hello again',
          ),
        ),
      ),
    );
  }
}
