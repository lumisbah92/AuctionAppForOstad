import 'dart:convert';

bidItem bidItemFromJson(String str) => bidItem.fromJson(json.decode(str));

String bidItemToJson(bidItem data) => json.encode(data.toJson());

class bidItem {
  bidItem({
    this.id,
    required this.userName,
    required this.bidPrice,
  });

  String? id;
  final String userName;
  final num bidPrice;

  factory bidItem.fromJson(Map<String, dynamic> json) => bidItem(
    id: json["id"],
    userName: json["userName"],
    bidPrice: json["bidPrice"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": userName,
    "price": bidPrice,
  };
}
