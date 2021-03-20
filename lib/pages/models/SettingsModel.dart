import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:MyE2/utils/Endpoints.dart';

import 'AppState.dart';

class SettingsModel {
  static Future updateSettings(
    AppState appState,
    String profileId,
  ) async {
    try {
      print('saving settings');

      final response = await http.put(
        Uri.https(API_HOST, '/user/settings'),
        body: jsonEncode(
          <String, String>{
            'profileId': profileId,
          },
        ),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${appState.idToken}',
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      inspect(response.body.toString());

      if (response.statusCode == 200) {
        print('Successfully updated settings');

        appState.settings['profileId'] = profileId;
      } else {
        if (response.statusCode == 400) {
          String message = response.body.toString();

          print(message);
        } else {}
      }
    } catch (e) {
      print('User settings ERROR: ');
      inspect(e);
    }
  }
}
