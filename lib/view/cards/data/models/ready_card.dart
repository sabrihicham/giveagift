import 'dart:math';

import 'package:giveagift/view/cards/data/models/shape.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/store/data/model/shop.dart';

class ReadyCardsResponse {
  ReadyCardsResponse({
    required this.status,
    required this.data,
    this.totalPages = 1,
  });

  final String status;
  final Data data;
  final int totalPages;

  factory ReadyCardsResponse.fromJson(Map<String, dynamic> json) =>
      ReadyCardsResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        totalPages: json["totalPages"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "totalPages": totalPages,
      };
}

class Data {
  Data({
    required this.cards,
    required String frontShape,
    required String backShape,
  }) {
    _frontShape = frontShape;
    _backShape = backShape;
  }

  late String _frontShape;
  late String _backShape;
  final List<CardData> cards;

  String get frontShape {
    return _frontShape.startsWith('/')
        ? _frontShape.replaceFirst('/', '')
        : _frontShape;
  }

  String get backShape {
    return _backShape.startsWith('/')
        ? _backShape.replaceFirst('/', '')
        : _backShape;
  }

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cards:
            List<CardData>.from(json["cards"].map((x) => CardData.fromJson(x))),
        frontShape: json["frontShapeImagePath"],
        backShape: json["backShapeImagePath"],
      );

  Map<String, dynamic> toJson() => {
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
        "frontShapeImagePath": _frontShape,
        "backShapeImagePath": _backShape,
      };
}

class CardData {
  CardData({
    required this.id,
    required this.shop,
    required this.price,
    this.frontShape,
    this.backShape,
    this.priority,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String id;
  final Shop? shop;
  final int price;
  String? frontShape;
  String? backShape;
  num? priority;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory CardData.fromJson(Map<String, dynamic> json) => CardData(
        id: json["_id"],
        shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
        price: json["price"],
        priority: json["priority"],
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]).toLocal(),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]).toLocal(),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "shop": shop?.toJson(),
        "price": price,
        "priority": priority,
        "createdAt": createdAt?.toUtc().toIso8601String(),
        "updatedAt": updatedAt?.toUtc().toIso8601String(),
        "__v": v,
      };

  Card toCard() {
    return Card(
      id: id,
      price: Price(value: price),
      shop: shop,
      isSpecial: true,
      priority: priority,
    );
  }
}

// class Shop {
//   final String id;
//   final String name;
//   final String logo;
//   final String description;
//   final String? link;
// }

const responseMock = {
  "status": "success",
  "results": 0,
  "data": {
    "frontShapeImagePath": "/specialCards/front-shape.webp",
    "backShapeImagePath": "/specialCards/back-shape.webp",
    "cards": [
      {
        "_id": "61f1b1b1b1b1b1b1b1b1b1b1",
        "shop": {
          "_id": "61f1b1b1b1b1b1b1b1b1b1",
          "name": "Elect",
          "logo":
              "/shops/shop-91288cd9-95b4-4c03-9c61-686355c2ca18-1719608972865.png"
        },
        "price": 100,
        "createdAt": "2022-01-01T00:00:00.000Z",
        "updatedAt": "2022-01-01T00:00:00.000Z",
        "__v": 0
      },
    ]
  }
};
