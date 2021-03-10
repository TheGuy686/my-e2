import 'Property.dart';

class Profile {
  String avatar;
  String alias;
  int owns;
  String tiles;
  int netWorth;
  double netProfit;
  double netProfitPercent;
  List<Property> properties;

  Profile(
      {this.avatar,
      this.alias,
      this.owns,
      this.tiles,
      this.netWorth,
      this.netProfit,
      this.netProfitPercent});

  factory Profile.fromJson(Map<String, dynamic> json) {
    //List<Property> properties = List<Property>.from(
    //    json['properties'].map((model) => Property.fromJson(model)));

    return Profile(
        avatar: json['info']['avatar'],
        alias: json['info']['alias'],
        owns: json['info']['owns'],
        tiles: json['info']['tiles'],
        netWorth: json['info']['netWorth'],
        netProfit: json['info']['netProfit'],
        netProfitPercent: json['info']['netProfitPercent']);
  }
}
