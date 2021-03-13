import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:my_e2/pages/dashboard/Avatar.dart';

import 'models/Profile.dart';

Future fetchProfile(updateProfile) async {
  try {
    print('doing request');
    final response =
        await http.get(Uri.https('23af369acba3.ap.ngrok.io', '/get-profile'));

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
    setState(() {
      prof = newProf;
    });
  }

  final e2Cur = "E\$";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double bgOpacity = 0.15;

    const giInfoTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );

    return Stack(
      children: [
        Positioned(
          left: -(screenWidth * 1.05),
          top: -(screenWidth),
          child: Transform.rotate(
            angle: 158.9,
            child: Opacity(
              opacity: bgOpacity,
              child: Image(
                image: AssetImage('lib/assets/earth2-blue.png'),
                width: 1000,
              ),
            ),
          ),
        ),
        Positioned(
          left: -(screenWidth / 5),
          top: (screenHeight * 0.25),
          child: Transform.rotate(
            angle: 25.2,
            child: Opacity(
              opacity: bgOpacity,
              child: Image(
                image: AssetImage('lib/assets/earth2-blue.png'),
                width: 1000,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 11, 5, 8),
          child: CustomScrollView(
            primary: false,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Avatar(),
                    Card(
                      elevation: 4,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prof.alias,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Owns ',
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: prof.owns.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: ' properties'),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Made up of ',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: prof.tiles.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: ' tiles'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Net Worth ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.5,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${e2Cur} ${prof.netWorth.toString()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Property Value Increase ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.5,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      '${e2Cur} ${prof.netProfit.toString()} (${prof.netProfitPercent.toString()}%)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
              SliverAppBar(
                pinned: true,
                snap: false,
                floating: true,
                expandedHeight: 140.0,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Properties'),
                  centerTitle: false,
                ),
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final prop = prof.properties[index];
                    //   inspect(prop);
                    return GestureDetector(
                      onTap: () => {print('clicked')},
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
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
                                  Positioned(
                                    top: 3,
                                    right: 3,
                                    child: Container(
                                      //color: Colors.white,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.fromLTRB(5, 4, 5, 4),
                                      child: Row(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: '${prop.tiles.toString()} ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: ' Tiles',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
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
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 4),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 2,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Price: ${e2Cur}${prop.price.toString()} (${prop.tradeValue.toString()})",
                                          style: giInfoTextStyle,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Price: ${e2Cur}${prop.location.location}',
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 2,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${prop.location.long}, ${prop.location.lat}',
                                          style: giInfoTextStyle,
                                        ),
                                        Icon(
                                          Icons.location_pin,
                                          color: Colors.red,
                                          size: 12.0,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: prof.properties.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
