import 'package:my_e2/pages/dashboard/models/Announcements.dart';
import 'package:my_e2/pages/dashboard/models/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  String username = 'ryanjcooke@hotmail.com';
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
}
