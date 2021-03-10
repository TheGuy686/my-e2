import 'Location.dart';

class Property {
  String id;
  String thumbnail;
  String link;
  String description;
  String price;
  String tradeValue;
  String tiles;
  Location location;

  Property(
      {this.id,
      this.thumbnail,
      this.link,
      this.description,
      this.price,
      this.tradeValue,
      this.tiles,
      this.location});

  factory Property.fromJson(Map<String, dynamic> json) {
    // Iterable l = json.decode(response.body);

    return Property(
        id: json['id'],
        thumbnail: json['thumbnail'],
        link: json['link'],
        description: json['description'],
        price: json['price'],
        tradeValue: json['tradeValue'],
        tiles: json['tiles'],
        location: json['location']);
  }
}
