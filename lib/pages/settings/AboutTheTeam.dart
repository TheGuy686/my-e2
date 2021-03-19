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
    double imageWidth = 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About the Tean'),
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(imageWidth / 2),
                              child: Image(
                                image: AssetImage('lib/assets/team/ryan.jpg'),
                                width: imageWidth,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  'Ryan Cooke',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Co Founder & Full Stack Architect',
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Rolf Streefkerk',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Co Founder & AWS Solution Architect',
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(imageWidth / 2),
                              child: Image(
                                image: AssetImage('lib/assets/team/rolf.jpg'),
                                width: imageWidth,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.blue,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                child: Text(
                  'Support Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
