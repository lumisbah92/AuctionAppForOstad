import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.id,
    required this.description,
    required this.name,
    required this.price,
  });

  String? id;
  final String description;
  final String name;
  final num price;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        description: json["description"],
        name: json["name"],
        price: json["price"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "name": name,
        "price": price,
      };
}
