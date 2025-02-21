// {
//   "status": "success",
//   "results": 2,
//   "data": [
//     {
//       "_id": "67adbca3d9b2018f30ce7154",
//       "sender": {
//         "name": "Guest",
//         "phone": "966555555556",
//         "email": "bla@gmail.com"
//       },
//       "recipient": {
//         "name": "Bla Bla",
//         "whatsappNumber": "966555555556"
//       },
//       "price": {
//         "value": 200
//       },
//       "text": {},
//       "shapes": [],
//       "isPaid": false,
//       "shop": "6761f19a6d21bfd8ed8fe371",
//       "isSpecial": true,
//       "createdAt": "2025-02-13T09:34:27.007Z",
//       "updatedAt": "2025-02-13T09:36:07.057Z"
//     },
//     {
//       "_id": "67adbdd6d9b2018f30ce71d2",
//       "sender": {
//         "name": "ABDULLAH ALTALHI",
//         "phone": "966538977791",
//         "email": "altalhi5@hotmail.com"
//       },
//       "recipient": {
//         "name": "ABDULLAH",
//         "whatsappNumber": "966555555556"
//       },
//       "price": {
//         "value": 10,
//         "fontFamily": "Cairo",
//         "fontSize": 40,
//         "fontColor": "#ffffff",
//         "fontWeight": 400
//       },
//       "text": {
//         "message": "مبروك",
//         "fontFamily": "Cairo",
//         "fontSize": 40,
//         "fontColor": "#ffffff",
//         "fontWeight": 400,
//         "xPosition": 39.39999999999998,
//         "yPosition": 80.01724137931035
//       },
//       "shapes": [
//         {
//           "position": {
//             "x": 197,
//             "y": 117.51724137931035
//           },
//           "shape": "67424c146d21bfd8ed8fa482",
//           "scale": 0.3,
//           "rotation": 0,
//           "_id": "67adbdd6d9b2018f30ce71d3"
//         }
//       ],
//       "isPaid": true,
//       "shop": "6771c8e86d21bfd8ed9009be",
//       "isSpecial": false,
//       "createdAt": "2025-02-13T09:39:34.262Z",
//       "updatedAt": "2025-02-13T09:40:16.968Z",
//       "orderNumber": 148,
//       "totalPricePaid": 20
//     }
//   ]
// }

import 'package:giveagift/view/cards/data/models/color.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/store/data/model/shop.dart';

class RecivedCardsResponse {
  RecivedCardsResponse({
    required this.status,
    required this.results,
    required this.data,
  });

  final String status;
  final int results;
  final List<RecivedCard> data;

  factory RecivedCardsResponse.fromJson(Map<String, dynamic> json) => RecivedCardsResponse(
    status: json["status"],
    results: json["results"],
    data: List<RecivedCard>.from(json["data"].map((x) => RecivedCard.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "results": results,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class RecivedCard {
  RecivedCard({
    required this.id,
    this.sender,
    required this.recipient,
    this.color,
    this.proColor,
    required this.price,
    required this.text,
    required this.isPaid,
    required this.shop,
    required this.isSpecial,
    required this.createdAt,
    required this.updatedAt,
    this.orderNumber,
    this.totalPricePaid,
    this.discountCode,
  });

  final String id;
  final Sender? sender;
  final Recipient recipient;
  final ColorModel? color;
  final ProColor? proColor;
  final Price price;
  final CardText? text;
  final bool isPaid;
  final Shop? shop;
  final bool isSpecial;
  final DateTime createdAt;
  final DateTime updatedAt;
  final num? orderNumber;
  final num? totalPricePaid;
  final DiscountCode? discountCode;

  factory RecivedCard.fromJson(Map<String, dynamic> json) => RecivedCard(
    id: json["_id"],
    sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
    recipient: Recipient.fromJson(json["recipient"]),
    color: json["color"] == null ? null : ColorModel.fromJson(json["color"]),
    proColor: json["proColor"] == null ? null : ProColor.fromJson(json["proColor"]),
    price: Price.fromJson(json["price"]),
    text: json["text"] == null ? null : CardText.fromJson(json["text"]),
    isPaid: json["isPaid"],
    shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
    isSpecial: json["isSpecial"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    orderNumber: json["orderNumber"],
    totalPricePaid: json["totalPricePaid"],
    discountCode: json["discountCode"] == null ? null : DiscountCode.fromJson(json["discountCode"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "sender": sender?.toJson(),
    "recipient": recipient.toJson(),
    "color": color?.toJson(),
    "proColor": proColor?.toJson(),
    "price": price.toJson(),
    "text": text?.toJson(),
    "isPaid": isPaid,
    "shop": shop?.toJson(),
    "isSpecial": isSpecial,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "orderNumber": orderNumber,
    "totalPricePaid": totalPricePaid,
    "discountCode": discountCode?.toJson(),
  };
}

class Sender {
  Sender({
    required this.name,
    required this.phone,
    required this.email,
  });

  final String name;
  final String phone;
  final String email;

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "email": email,
  };
}
