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

  Profile(
      {this.avatar = 'na',
      this.alias = 'na',
      this.owns = 0,
      this.tiles = 0,
      this.netWorth = 0,
      this.netProfit = 0,
      this.netProfitPercent = 0});

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
