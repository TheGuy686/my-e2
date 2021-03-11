import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:my_e2/pages/dashboard/Avatar.dart';
import 'package:my_e2/pages/dashboard/models/Property.dart';

import 'models/Profile.dart';

Future fetchProfile(updateProfile) async {
  try {
    print('doing request');
    final response =
        await http.get(Uri.https('b4502133dca6.ap.ngrok.io', '/get-profile'));

    updateProfile(Profile.fromJson(jsonDecode(response.body)));

    // if (response.statusCode == 200) {
    //   // If the server did return a 200 OK response,
    //   // then parse the JSON.
    // } else {
    //   // If the server did not return a 200 OK response,
    //   // then throw an exception.
    //   throw Exception('Failed to load album');
    // }
  } catch (e) {
    inspect(e);
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future futureProfile;
  Profile prof = Profile();

  @override
  void initState() {
    super.initState();
  }

  void _updateProfile(Profile newProf) {
    print('UPDATED PROFILE FROM HERE');
    setState(() {
      prof = newProf;

      inspect(prof);
    });
  }

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashbaord'),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          futureProfile = fetchProfile(_updateProfile);
        },
        child: Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Avatar(),
                    ],
                  ),
                  Card(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [Text('User: ' + prof.alias)],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Owns: ' +
                                      prof.owns.toString() +
                                      ' properties',
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Tiles: ' + prof.tiles.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Net Worth: E\$' + prof.netWorth.toString(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Net Profit: E\$' +
                                      prof.netProfit.toString() +
                                      ' (' +
                                      prof.netProfitPercent.toString() +
                                      '%)',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                padding: EdgeInsets.all(24),
                itemCount: prof.properties.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.amber,
                    child: Center(
                      child: Text(
                        prof.properties[index].description,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
