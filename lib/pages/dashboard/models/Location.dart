class Location {
  String location;
  String long;
  String lat;

  Location({this.long, this.lat, this.location});

  factory Location.fromJson(Map<String, dynamic> locJson) {
    return Location(
      long: locJson['long'],
      lat: locJson['lat'],
      location: locJson['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': this.lat,
      'long': this.long,
      'location': this.location,
    };
  }
}
