import 'package:MyE2/pages/classes/globals.dart';

class Location {
  String location;
  String long;
  String lat;

  Location({this.long, this.lat, this.location});

  factory Location.fromJson(Map<String, dynamic> locJson) {
    p('JSON: ' + locJson.toString());

    return Location(
        long: locJson['long'],
        lat: locJson['lat'],
        location: locJson['location']);
  }
}
