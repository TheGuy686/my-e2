import 'dart:developer';

import 'package:MyE2/pages/classes/globals.dart';

import 'Location.dart';

class Property {
  String id;
  String thumbnail;
  String link;
  String description;
  String price;
  String tradeValue;
  int tiles;
  Location location;

  Property({
    this.id,
    this.thumbnail,
    this.link,
    this.description,
    this.price,
    this.tradeValue,
    this.tiles,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'thumbnail': this.thumbnail,
      'link': this.link,
      'description': this.description,
      'price': price,
      'tradeValue': this.tradeValue,
      'tiles': this.tiles,
      'loc': this.location.toJson(),
    };
  }

  factory Property.fromJson(Map<dynamic, dynamic> json) {
    return Property(
      id: json['id'],
      thumbnail: json['thumbnail'],
      link: json['link'],
      description: json['description'],
      price: json['price'],
      tradeValue: json['tradeValue'],
      tiles: json['tiles'],
      location: Location.fromJson(
        json['loc'],
      ),
    );
  }
}
