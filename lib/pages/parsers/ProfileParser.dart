import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:puppeteer/puppeteer.dart';

class ProfileParser {
  String id;

  ProfileParser({this.id});

  factory ProfileParser.fromJson(Map<dynamic, dynamic> json) {
    // Iterable l = json.decode(response.body);

    return ProfileParser();
  }
}
