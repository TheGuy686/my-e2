import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:my_e2/pages/dashboard/models/Announcements.dart';
import 'package:my_e2/pages/dashboard/models/Profile.dart';
import 'package:my_e2/utils/Endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class AppState {
  String email = 'ryanjcooke@hotmail.com';
  String username = 'theguy';
  String password = 'Luvmajesus1!*';
  String idToken = '';
  String refreshToken = '';
  String accessToken = '';

  Map<String, dynamic> settings = {
    'profileId': 'f108dd87-0202-41b4-99b6-b075323f68ea',
  };

  Profile prof = Profile();
  Announcements annons = Announcements();

  AppState() {
    _initSettings();
  }

  _initSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String idt = prefs.getString('id_token');

    if (idt != '') {
      idToken = idt;
      refreshToken = prefs.getString('refresh_token');
      accessToken = prefs.getString('access_token');
    }
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("id_token");
    prefs.remove("refresh_token");
    prefs.remove("access_token");
  }

  Future fetchProfile(updateProfile) async {
    try {
      Uri url = Uri.https(
        API_HOST,
        '/api/user/profile',
        {
          'profileId': settings['profileId'],
        },
      );

      print('fetching profile: ');

      print(url);

      print(idToken);

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${idToken}',
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (response.statusCode == 200) {
        updateProfile(Profile.fromJson(jsonDecode(response.body)));
      } else {
        inspect(jsonDecode(response.body));
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print('PROFILE ERROR: ' + e.toString());
    }
  }

  Future fetchAnnouncements(updateAnnons) async {
    try {
      Uri url = Uri.https(
        API_HOST,
        '/api/announcements',
        {
          'profileId': 'f108dd87-0202-41b4-99b6-b075323f68ea',
        },
      );

      print('doing request: fetchAnnouncements');

      print("Basic ${idToken}");

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${idToken}',
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );
      inspect(response.body.toString());
      if (response.statusCode == 200) {
        updateAnnons(Announcements.fromJson(jsonDecode(response.body)));
      } else {
        inspect(response.body.toString());
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print('ANNONS ERROR: ');
      inspect(e);
    }
  }
}
