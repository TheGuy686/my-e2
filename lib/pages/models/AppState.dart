import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:my_e2/pages/dashboard/models/Announcements.dart';
import 'package:my_e2/pages/dashboard/models/Profile.dart';
import 'package:my_e2/utils/Endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class AppState {
  String email = 'ryanjcooke@hotmail.com';
  String username = 'theguy';
  String password = 'Luvmajesus1!*';
  String idToken = '';
  String refreshToken = '';
  String accessToken = '';

  String profileJson = '';

  SharedPreferences prefs;

  Map<String, dynamic> settings = {
    'profileId': '',
  };

  Profile prof = Profile();
  Announcements annons = Announcements();

  AppState() {
    initSettings();
  }

  initSettings() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    email = prefs.getString('email');

    String idt = prefs.getString('id_token');

    if (idt != '') {
      idToken = idt;
      refreshToken = prefs.getString('refresh_token');
      accessToken = prefs.getString('access_token');
    }
  }

  Future logout() async {
    prefs.remove("id_token");
    prefs.remove("refresh_token");
    prefs.remove("access_token");
  }

  Future fetchSettings() async {
    try {
      Uri url = Uri.https(
        API_HOST,
        '/api/user/settings',
        {
          'profileId': settings['profileId'],
        },
      );

      print('fetching settings: ');

      print(url);

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${idToken}',
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body) as Map;

        Settings.setValue<String>('profile-id', json['profileId']);
      }
    } catch (e) {}
  }

  Future fetchProfile(updateProfile) async {
    var key = utf8.encode(email);

    String shaKay = sha1.convert(key).toString();

    String profilleCache = prefs.getString(shaKay);

    print(profilleCache);

    if (profilleCache != null) {
      updateProfile(Profile.fromJson(jsonDecode(profilleCache)));
    }

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

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${idToken}',
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (response.statusCode == 200) {
        await prefs.setString(shaKay, response.body.toString());

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
      Uri url = Uri.https(API_HOST, '/api/announcements');

      print('doing request: fetchAnnouncements');

      print("Bearer ${idToken}");

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
