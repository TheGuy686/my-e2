import 'dart:developer';
import 'Announcement.dart';

class Announcements {
  List<Announcement> annons = [];

  Announcements();

  factory Announcements.fromJson(Map<dynamic, dynamic> json) {
    Announcements annons = Announcements();

    json['announcements']
        .forEach((v) => annons.annons.add(Announcement.fromJson(v)));

    return annons;
  }
}
