import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:my_e2/pages/dashboard/Avatar.dart';
import 'package:my_e2/pages/dashboard/models/Property.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

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
    });
  }

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  final e2Cur = "E\$";

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
                                  'Net Worth: $e2Cur' +
                                      prof.netWorth.toString(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Net Profit: $e2Cur' +
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
                  final prop = prof.properties[index];
                  inspect(prop);
                  return GestureDetector(
                    onTap: () => {print('clicked')},
                    child: Card(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.5),
                              topRight: Radius.circular(4.5),
                              bottomLeft: Radius.zero,
                              bottomRight: Radius.zero,
                            ),
                            child: Image.network(
                              prop.thumbnail,
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: 100,
                            ),
                          ),
                          Container(
                            color: Colors.orange,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                                child: Text(
                                  prop.description,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text('Tiles: ' + prop.tiles.toString()),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Price: $e2Cur" +
                                  prop.price.toString() +
                                  " (" +
                                  prop.tradeValue.toString() +
                                  ")"),
                            ],
                          ),
                        ],
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
