import 'dart:developer';

import 'package:MyE2/pages/classes/globals.dart';
import 'package:flutter/cupertino.dart';

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

  factory Property.fromJson(Map<dynamic, dynamic> json) {
    p('JSON PROPERTY ' + json.toString());

    return Property(
      id: json['id'],
      thumbnail: json['thumbnail'],
      link: json['link'],
      description: json['desc'],
      price: json['price'],
      tradeValue: json['tradeValue'],
      tiles: json['tiles'],
      location: Location.fromJson(
        json['loc'],
      ),
    );
  }
}
