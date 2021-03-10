class Location {
  String location;
  double long;
  double lat;

  Location({this.long, this.lat, this.location});

  factory Location.fromJson(Map<String, dynamic> locJson) {
    return Location(
        long: locJson['long'],
        lat: locJson['lat'],
        location: locJson['location']);
  }
}
