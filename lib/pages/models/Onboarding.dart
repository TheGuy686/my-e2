import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:my_e2/utils/Endpoints.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Onboarding {
  static Future login(String username, String password) async {
    // prefs.getInt('counter')
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      print('doing login');
      final response = await http.post(
        Uri.https(AUTH_HOST, '/api/identity/authenticate'),
        body: jsonEncode(
          <String, String>{
            'username': username,
            'password': password,
          },
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;

        json.forEach((k, v) async {
          await prefs.setString(k, v);
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to Login');
      }
    } catch (e) {
      print('PROFILE ERROR: ');
      inspect(e);
    }
  }

  static Future register(
    String email,
    String username,
    String password,
    String title,
  ) async {
    try {
      print('doing register');
      final response = await http.post(
        Uri.https(AUTH_HOST, '/api/identity/register'),
        body: jsonEncode(
          <String, String>{
            'username': username,
            'email': email,
            'password': password,
            'title': title
          },
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;

        inspect(json);
      } else {
        throw Exception('Failed to Regeister');
      }
    } catch (e) {
      print('PROFILE ERROR: ');
      inspect(e);
    }
  }
}
