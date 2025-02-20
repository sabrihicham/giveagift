// {
//     "status": "success",
//     "results": 1,
//     "data": [
//         {
//             "_id": "667f268d7fa6ac7aad47feae",
//             "name": "Elect",
//             "logo": "/shops/shop-91288cd9-95b4-4c03-9c61-686355c2ca18-1719608972865.png"
//         }
//     ]
// }

import 'package:giveagift/view/cards/data/models/category.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShopsResponse {
  ShopsResponse({
    required this.status,
    required this.data,
  });

  final String status;
  final List<Shop> data;

  factory ShopsResponse.fromJson(Map<String, dynamic> json) => ShopsResponse(
        status: json["status"],
        data: List<Shop>.from(json["data"].map((x) => Shop.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Shop {
  Shop({
    required this.id,
    required this.name,
    required this.logo,
    this.description = '',
    this.link,
    this.email,
    this.phone,
    this.isOnline,
    this.priority,
    this.showInHome,
    this.category,
  });

  final String id;
  final String name;
  final String logo;
  final String description;
  final String? email;
  final String? phone;
  final String? link;
  final bool? isOnline;
  final num? priority;
  final bool? showInHome;
  final Category? category;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["_id"],
        name: json["name"],
        logo: json["logo"] ?? '',
        description: json["description"] ?? '',
        link: json["link"],
        email: json["email"],
        phone: json["phone"],
        isOnline: json["isOnline"],
        priority: json["priority"],
        showInHome: json["showInHome"],
        category: json["category"] != null ? Category.fromJson(json["category"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "logo": logo,
        "description": description,
        "link": link,
        "email": email,
        "phone": phone,
        "isOnline": isOnline,
        "priority": priority,
        "showInHome": showInHome,
        "category": category?.toJson(),
      };

  void launchShop() {
    if (link != null) {
      launchUrlString(link!);
    }
  }

  void callShop() {
    if (phone != null) {
      launchUrlString('tel:$phone');
    }
  }
}

class ShopDetailsResponse {
  ShopDetailsResponse({
    required this.status,
    this.message,
    required this.data,
  });

  final String status;
  final String? message;
  final ShopDetails data;

  factory ShopDetailsResponse.fromJson(Map<String, dynamic> json) => ShopDetailsResponse(
        status: json["status"],
        data: ShopDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class ShopDetails {
  ShopDetails({
    required this.shop,
    required this.frontShapeImagePath,
    required this.backShapeImagePath,
    required this.readyCards,
  });

  final Shop shop;
  final String frontShapeImagePath;
  final String backShapeImagePath;
  final List<CardData> readyCards;

  factory ShopDetails.fromJson(Map<String, dynamic> json) => ShopDetails(
      shop: Shop.fromJson(json["shop"]),
      frontShapeImagePath: json["frontShapeImagePath"],
      backShapeImagePath: json["backShapeImagePath"],
      readyCards: List<CardData>.from(json["readyCards"].map((x) => CardData.fromJson(x))),
    );

  Map<String, dynamic> toJson() => {
      "shop": shop.toJson(),
      "frontShapeImagePath": frontShapeImagePath,
      "backShapeImagePath": backShapeImagePath,
      "readyCards": List.from(readyCards.map((x) => x.toJson())),
    };
}