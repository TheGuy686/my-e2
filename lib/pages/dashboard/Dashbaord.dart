import 'dart:io';

import 'package:MyE2/main.dart';
import 'package:MyE2/pages/classes/globals.dart';
import 'package:MyE2/pages/dashboard/subpages/PropertyDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'dart:async';
import 'package:MyE2/pages/dashboard/Avatar.dart';
import 'package:MyE2/pages/models/AppState.dart';
import 'package:MyE2/pages/settings/SettingsPage.dart';

import 'AnnouncementTimer.dart';
import 'models/Announcements.dart';
import 'models/Profile.dart';
import "package:intl/intl.dart";

class Dashboard extends StatefulWidget {
  AppState appState;

  bool isConnected = true;

  Dashboard({Key key, @required this.appState}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

String formatNumber(num num) {
  var f = NumberFormat("###,###,###,###.0#", "en_US");
  return f.format(num);
}

class _DashboardState extends State<Dashboard> {
  Future futureAnnouncements;
  Future futureProfile;

  final e2Cur = "E\$";
  bool isLoading = false;

  void _setConnectionState() {
    setState(
      () => {
        widget.isConnected = widget.appState.internetCon.isConnected,
      },
    );
  }

  @override
  void initState() {
    super.initState();

    widget.appState.internetCon.onChange(
      'dashboard-con',
      () async {
        _setConnectionState();
      },
    );

    _updatePageState();
  }

  void _updatePageState() {
    if (!widget.isConnected) return;

    if (widget.appState.hasProfileId()) {
      setState(
        () => {
          isLoading = true,
        },
      );
      widget.appState.fetchProfile(_updateProfile);
      widget.appState.fetchAnnouncements(_updateAnnons);
    }
  }

  void _updateAnnons(Announcements newAnnons) {
    setState(
      () {
        widget.appState.annons = newAnnons;
      },
    );
  }

  void _updateProfile(Profile newProf) {
    setState(
      () {
        widget.appState.prof = newProf;
        isLoading = false;
      },
    );
  }

  Widget _renderAnnons() {
    if (widget.appState.annons.annons.length == 0) return Container();

    return AnnouncementTimer(
      annon: widget.appState.annons.annons[0],
    );
  }

  TextStyle giInfoTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 11,
  );

  _renderGrid() {
    String txt = '';

    if (!widget.appState.hasProfileId()) {
      txt =
          'Please connect your account with \nan Earth2 profile id.\nThis is located at the end of proifle \nlink in the earth2.io website. \n\nFor eg. https://app.earth2.io/#profile/(f108dd87-0202-41b4-99b6-b075323f68ea)';
    }

    if (isLoading) {
      txt =
          'Currently loading please wait.\nThis could take a while on the first time';
    }

    if (txt != '') {
      return SliverToBoxAdapter(
        child: IntrinsicHeight(
          child: Center(
            child: (() {
              var text = Text(
                txt,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              );

              if (isLoading) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      CircularProgressIndicator(),
                      SizedBox(height: 30),
                      text,
                    ],
                  ),
                );
              }

              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    text,
                  ],
                ),
              );
            })(),
          ),
        ),
      );
    }

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final prop = widget.appState.prof.properties[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => PropertyDetails(
                    appState: widget.appState,
                    url: 'https://app.earth2.io/${prop.link}',
                  ),
                ),
              );
            },
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
                            prop.description.length > 18
                                ? prop.description.substring(0, 18) + '...'
                                : prop.description,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 8, 5, 4),
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
                          SizedBox(
                            width: double.infinity,
                            height: 1,
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
        childCount: widget.appState.prof.properties.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double bgOpacity = 0.15;

    _renderConnectionStatus() {
      if (widget.isConnected) {
        return SliverToBoxAdapter(child: Container());
      }

      return SliverToBoxAdapter(
        child: Container(
          width: double.infinity,
          color: Colors.red,
          child: SizedBox(
            height: 35,
            child: Center(
              child: Text(
                'There is no internet connection',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashbaord'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      SettingsPage(appState: widget.appState),
                ),
              );

              _updatePageState();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
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
                  child: Column(
                    children: [
                      _renderAnnons(),
                      SizedBox(
                        width: double.infinity,
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Avatar(avatar: widget.appState.prof.avatar),
                          Card(
                            elevation: 4,
                            child: Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 7, 10, 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.appState.prof.alias,
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
                                            text: formatNumber(
                                              widget.appState.prof.owns,
                                            ),
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
                                            text: formatNumber(
                                              widget.appState.prof.tiles,
                                            ),
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
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                                    text:
                                        '${e2Cur} ${formatNumber(widget.appState.prof.netWorth)}',
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
                                        '${e2Cur} ${formatNumber(widget.appState.prof.netProfit)} (${formatNumber(widget.appState.prof.netProfitPercent)}%)',
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
                  floating: false,
                  expandedHeight: 140.0,
                  flexibleSpace: const FlexibleSpaceBar(
                    title: Text('Properties'),
                    centerTitle: false,
                  ),
                ),
                _renderConnectionStatus(),
                _renderGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
