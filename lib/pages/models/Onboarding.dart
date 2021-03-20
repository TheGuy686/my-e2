import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:my_e2/utils/Endpoints.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Onboarding {
  static Future login(
    String username,
    String password,
    successCb,
    errorCb,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(username + ' : ' + password);

    try {
      print('doing login');
      final response = await http.post(
        Uri.https(API_HOST, '/api/identity/authenticate'),
        body: jsonEncode(
          <String, String>{
            'username': username,
            'password': password,
          },
        ),
      );

      final json = jsonDecode(response.body) as Map;

      if (response.statusCode == 200) {
        json.forEach((k, v) async {
          await prefs.setString(k, v);
        });

        print('logged in successfully');

        successCb();
      } else {
        if (json['message'] == 'Authentication failed') {
          errorCb('Username or Password was wrong');
        } else {
          errorCb(json['message']);
        }
      }
    } catch (e) {
      print('PROFILE ERROR: ');
      inspect(e);
      errorCb(e.toString());
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
        Uri.https(API_HOST, '/api/identity/register'),
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
