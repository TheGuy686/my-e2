import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:MyE2/pages/classes/ConnectionStatus.dart';
import 'package:MyE2/pages/classes/globals.dart';
import 'package:MyE2/pages/parsers/ProfileParser.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:MyE2/pages/dashboard/models/Announcements.dart';
import 'package:MyE2/pages/dashboard/models/Profile.dart';
import 'package:MyE2/utils/Endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class AppState {
  ConnectionStatus internetCon = ConnectionStatus();

  String email = '';
  String username = '';
  String password = '';
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

    settings['profileId'] = prefs.getString('profile-id');

    String idt = prefs.getString('id_token');

    if (idt != '') {
      idToken = idt;
      refreshToken = prefs.getString('refresh_token');
      accessToken = prefs.getString('access_token');
    }
  }

  bool hasProfileId() {
    try {
      String profileId = settings['profileId'];

      return profileId != '';
    } catch (e) {
      return false;
    }
  }

  bool hasProps() {
    return prof.properties.isEmpty;
  }

  Future logout() async {
    idToken = '';
    refreshToken = '';
    accessToken = '';

    prefs.remove("id_token");
    prefs.remove("refresh_token");
    prefs.remove("access_token");
  }

  bool profileUpdatedInLast15Min() {
    try {
      var key = utf8.encode(email);

      String shaKay = sha1.convert(key).toString();

      String uts = prefs.getString(shaKay + '-last-profile-updated-ts');

      if (uts == null) {
        (() async {
          await prefs.setString(
            shaKay + '-last-profile-updated-ts',
            DateTime.now().millisecondsSinceEpoch.toString(),
          );
        })();

        return false;
      }

      int after = DateTime.now().millisecondsSinceEpoch;

      double mins = (after - int.parse(uts)) / 60000;

      return mins < 180;
    } catch (e) {
      p(e.toString());

      return false;
    }
  }

  Future fetchSettings() async {
    try {
      Uri url = Uri.https(
        API_HOST,
        '/user/settings',
        {
          'profileId': settings['profileId'],
        },
      );

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

        await prefs.setString('profile-id', json['profileId']);
      }
    } catch (e) {}
  }

  void _storeProfileState(key, Profile newProfile) async {
    await prefs.remove(key);
    await prefs.setString(
      key,
      jsonEncode(
        newProfile.toJson(),
      ),
    );
  }

  Future fetchProfile(updateProfile) async {
    var key = utf8.encode(email);

    print('UPDATING PROFILE');

    String shaKay = sha1.convert(key).toString();

    String profilleCache = prefs.getString(shaKay);

    if (profilleCache != null) {
      updateProfile(Profile.fromJson(jsonDecode(profilleCache)));
    }

    try {
      await ProfileParser.parseFromPage(
        settings['profileId'],
        (newProfile) {
          updateProfile(newProfile);
          _storeProfileState(shaKay, newProfile);
        },
      );
    } catch (e) {
      if (profileUpdatedInLast15Min() &&
          profilleCache != null &&
          profilleCache != '') {
        p('protedted against network bombardment');
        return;
      }

      try {
        Uri url = Uri.https(
          API_HOST,
          '/user/profile',
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
          Profile newProf = Profile.fromJson(jsonDecode(response.body));

          _storeProfileState(shaKay, newProf);

          updateProfile(newProf);

          (() async {
            await prefs.setString(
              shaKay + '-last-profile-updated-ts',
              DateTime.now().millisecondsSinceEpoch.toString(),
            );
          })();
        } else {
          throw Exception(
              'Filated to get profile: ' + response.body.toString());
        }
      } catch (e) {
        print('PROFILE ERROR: ' + e.toString());
      }
    }
  }

  Future fetchAnnouncements(updateAnnons) async {
    try {
      Uri url = Uri.https(API_HOST, '/announcements');

      print('doing request: fetchAnnouncements');

      print("Bearer ${idToken}");

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${idToken}',
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (response.statusCode == 200) {
        Announcements annons =
            Announcements.fromJson(jsonDecode(response.body));

        if (annons.annons[0].endTimestamp <
            DateTime.now().millisecondsSinceEpoch) {
          return;
        }

        updateAnnons(annons);
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
