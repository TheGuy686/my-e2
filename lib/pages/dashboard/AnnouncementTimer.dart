import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:developer';

import 'models/Announcement.dart';

class AnnouncementTimer extends StatefulWidget {
  final Announcement annon;

  @override
  AnnouncementTimer({Key key, @required this.annon}) : super(key: key);

  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<AnnouncementTimer> {
  DateTime counterDate;
  Duration difference;
  int months = 0;
  int days = 0;
  int hours = 0;
  int mins = 0;
  int secs = 0;

  @override
  void initState() {
    super.initState();

    _ressetCounter();

    _startTimer();
  }

  _ressetCounter() {
    setState(() {
      counterDate =
          DateTime.fromMillisecondsSinceEpoch(widget.annon.endTimestamp);

      difference = counterDate.difference(DateTime.now());

      days = difference.inDays;
      hours = difference.inHours - (24 * days);
      mins = difference.inMinutes - (60 * difference.inHours);
      secs = difference.inSeconds - (60 * difference.inMinutes);
    });
  }

  _startTimer() {
    final duration = Duration(seconds: 1);
    Timer.periodic(duration, (timer) {
      // Stop the timer when it matches a condition
      if (difference.inSeconds == 0) {
        timer.cancel();
      }

      _ressetCounter();
    });
  }

  TextStyle timerTxt = TextStyle(fontWeight: FontWeight.bold, fontSize: 28);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 14, 10, 14),
          child: Center(
            child: Column(
              children: [
                Text(
                  widget.annon.announcement,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 5),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: days.toString(),
                            style: timerTxt,
                          ),
                          TextSpan(text: 'd, '),
                          TextSpan(
                            text: hours.toString(),
                            style: timerTxt,
                          ),
                          TextSpan(text: 'h, '),
                          TextSpan(
                            text: mins.toString(),
                            style: timerTxt,
                          ),
                          TextSpan(text: 'm, '),
                          TextSpan(
                            text: secs.toString(),
                            style: timerTxt,
                          ),
                          TextSpan(text: 's'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
