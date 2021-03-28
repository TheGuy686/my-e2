import 'Property.dart';

class Profile {
  String avatar;
  String alias;
  int owns;
  int tiles;
  double netWorth;
  double netProfit;
  double netProfitPercent;
  List<Property> properties = [];

  Profile({
    this.avatar = 'na',
    this.alias = 'na',
    this.owns = 0,
    this.tiles = 0,
    this.netWorth = 0,
    this.netProfit = 0,
    this.netProfitPercent = 0,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    Profile prof = Profile(
      avatar: json['info']['avatar'],
      alias: json['info']['alias'],
      owns: json['info']['owns'],
      tiles: json['info']['tiles'],
      netWorth: json['info']['networth'],
      netProfit: json['info']['netProfit'],
      netProfitPercent: json['info']['netProfitPercent'],
    );

    json['properties']
        .forEach((k, v) => prof.properties.add(Property.fromJson(v)));

    return prof;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> props = {};

    properties.forEach(
      (prop) {
        props[prop.id] = prop.toJson();
      },
    );

    return {
      'info': {
        'avatar': this.avatar,
        'alias': this.alias,
        'owns': this.owns,
        'tiles': this.tiles,
        'networth': this.netWorth,
        'netProfitPercent': this.netProfitPercent,
      },
      'properties': props
    };
  }
}
