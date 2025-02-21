import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cards/data/models/color.dart';
import 'package:giveagift/view/cards/data/models/shape.dart';
import 'package:giveagift/view/store/data/model/shop.dart';

class GetCardsResponse {
  GetCardsResponse({
    required this.status,
    this.message,
    required this.data,
  });

  final String status;
  final String? message;
  final List<Card> data;

  factory GetCardsResponse.fromJson(Map<String, dynamic> json) => GetCardsResponse(
    status: json["status"],
    message: json['message'],
    data: List<Card>.from(json["data"].map((x) => Card.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}


class GetCardResponse {
  GetCardResponse({
    required this.status,
    this.message,
    this.data,
  });

  final String status;
  final String? message;
  final Card? data;

  factory GetCardResponse.fromJson(Map<String, dynamic> json) => GetCardResponse(
    status: json["status"],
    message: json['message'],
    data: json["data"] == null ? null : Card.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
} 

// {"status":"success","data":{"isSpecial":true,"isPaid":false,"shop":"66dae18415995349e8ab5d77","user":"66e93f6135902c532c975e02","price":{"value":777},"isDelivered":false,"recipient":{"name":"Hicham Sabri","whatsappNumber":"966659668559"},"_id":"66e9d6692da346bd884be331","createdAt":"2024-09-17T19:20:09.806Z","updatedAt":"2024-09-17T19:20:09.806Z","__v":0}}

class CreateCardResponse {
  CreateCardResponse({
    required this.status,
    this.message,
    this.data,
  });

  final String status;
  final String? message;
  // final CreateCardData? data;
  final dynamic data;

  factory CreateCardResponse.fromJson(Map<String, dynamic> json) => CreateCardResponse(
    status: json["status"],
    message: json['message'],
    // data: json["data"] == null ? null : CreateCardData.fromJson(json["data"]),
    data: json["data"]
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    // "data": data?.toJson(),
    "data": data
  };
}

// TODO: ADD Pro Color
class CreateCardData {
  CreateCardData({
    this.id,
    this.isSpecial,
    this.shop,
    this.color,
    this.proColor,
    this.shapes,
    this.price,
    this.text,
    this.recipient,
    this.receiveAt,
    this.celebrateIcon,
    this.celebrateLink
  });

  final String? id;
  final bool? isSpecial;
  final String? shop;
  final String? color;
  final String? proColor;
  final List<CreateCardShapeData>? shapes;
  final Price? price;
  final CardText? text;
  final Recipient? recipient;
  final DateTime? receiveAt;
  final String? celebrateIcon;
  final String? celebrateLink;

  factory CreateCardData.fromJson(Map<String, dynamic> json) => CreateCardData(
    id: json["_id"],
    isSpecial: json["isSpecial"],
    shop: json["shop"],
    color: json["color"],
    proColor: json["proColor"],
    shapes: json["shapes"] == null ? null : List<CreateCardShapeData>.from(json["shapes"].map((x) => CardShape.fromJson(x))),
    price: json["price"] == null ? null : Price.fromJson(json["price"]),
    text: json["text"] == null ? null : CardText.fromJson(json["text"]),
    recipient: json["recipient"] == null ? null : Recipient.fromJson(json["recipient"]),
    receiveAt: json["receiveAt"] == null ? null : DateTime.parse(json["receiveAt"]).toLocal(),
    celebrateIcon: json["celebrateIcon"],
    celebrateLink: json["celebrateLink"]
  );

  Map<String, dynamic> toJson() => {
    if(id != null) "_id": id,
    if(isSpecial != null) "isSpecial": isSpecial,
    if(shop != null)"shop": shop, 
    if(color != null) "color": color,
    if(proColor != null) "proColor": proColor,
    if(shapes != null) "shapes": List<dynamic>.from(shapes!.map((x) => x.toJson())),
    if(price != null) "price": price?.toJson(),
    if(text != null) "text": text?.toJson(),
    if(recipient != null) "recipient": recipient?.toJson(),
    if(receiveAt != null) "receiveAt": receiveAt?.toUtc().toIso8601String(),
    if(celebrateIcon != null) "celebrateIcon": celebrateIcon,
    if(celebrateLink != null) "celebrateLink": celebrateLink
  };
}

class CardShape {
  CardShape({
    required this.shape,
    this.position,
    this.scale = 1,
    this.rotation = 0,
    this.price,
  });

  final Shape shape;
  final Position? position;
  final num scale;
  final num rotation;
  final num? price;

  factory CardShape.fromJson(Map<String, dynamic> json) => CardShape(
    shape: Shape.fromJson(json["shape"]),
    position: Position.fromJson(json["position"]),
    scale: json["scale"],
    rotation: json["rotation"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "shape": shape.toJson(),
    "position": position?.toJson(),
    "scale": scale,
    "rotation": rotation,
    if(price != null) "price": price,
  };

  CardShape toRadians() {
    return CardShape(
      shape: shape,
      position: position,
      scale: scale,
      rotation: rotation * (pi / 180),
    );
  }
}

class CreateCardShapeData {
  CreateCardShapeData({
    required this.shape,
    this.position,
    this.scale = 1,
    this.rotation = 0,
  }) : assert(scale >= 0 && scale <= 1), 
       assert(rotation >= 0 && rotation <= 360),  
       assert(shape.isNotEmpty);

  final String shape;
  final Position? position;
  final double scale;
  final double rotation;

  factory CreateCardShapeData.fromJson(Map<String, dynamic> json) => CreateCardShapeData(
    shape: json["shape"],
    position: Position.fromJson(json["position"]),
    scale: json["scale"].toDouble(),
    rotation: json["rotation"],
  );

  Map<String, dynamic> toJson() => {
    "shape": shape,
    "position": position?.toJson(),
    "scale": scale,
    "rotation": rotation,
  };
}

class Position {
  const Position({
    this.x = 0,
    this.y = 0,
  });

  final double x;
  final double y;

  static const zero = Position(x: 0, y: 0);

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    x: json["x"].toDouble(),
    y: json["y"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "x": x,
    "y": y,
  };

  // OPERATIONS
  Position operator +(Position other) => Position(x: x + other.x, y: y + other.y);
  Position operator -(Position other) => Position(x: x - other.x, y: y - other.y);
  Position operator *(double other) => Position(x: x * other, y: y * other);
  Position operator /(double other) => Position(x: x / other, y: y / other);

  // COMPARISON
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Position && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'Position(x: $x, y: $y)';
}

class CardResponse {
  CardResponse({
    required this.status,
    required this.data,
  });

  final String status;
  final Card data;

  factory CardResponse.fromJson(Map<String, dynamic> json) => CardResponse(
    status: json["status"],
    data: Card.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Card {
  Card({
    this.id = '',
    this.isSpecial = true,
    this.color,
    this.proColor,
    this.shop,
    this.shapes,
    this.price,
    this.text,
    this.recipient,
    this.isPaid,
    this.isDelivered,
    this.receiveAt,
    this.celebrateIcon,
    this.celebrateQR,
    this.priceAfterDiscount,
    this.discountCode,
    this.paidAt,
    this.autoReminderSent,
    this.priority,
  });

  final String id;
  final bool isSpecial;
  final ColorModel? color;
  final ProColor? proColor;
  final Shop? shop;
  final List<CardShape>? shapes;
  final Price? price;
  final CardText? text;
  final Recipient? recipient;
  final bool? isPaid;
  final bool? isDelivered;
  final DateTime? receiveAt;
  final String? celebrateIcon;
  final String? celebrateQR;
  num? priceAfterDiscount;
  DiscountCode? discountCode;
  DateTime? paidAt;
  bool? autoReminderSent;
  num? priority;

  double get totalPrice => priceAfterDiscount?.toDouble() ?? (
      (price?.value ?? 0) +
      (proColor != null ? (proColor?.price ?? 0.0) : 0.0) +
      (shapes != null && shapes!.any((element) => element.shape.price != null) ? shapes!.fold(0.0, (prev, element) => prev + (element.shape.price ?? 0)) : 0.0) +
      (celebrateIcon != null ? (SharedPrefs.instance.appConfig?.celebrateIconPrice ?? 0.0) : 0.0) +
      (celebrateQR != null ? (SharedPrefs.instance.appConfig?.celebrateLinkPrice ?? 0.0) : 0.0) + 0.00);

  double get totalWithVat => priceAfterDiscount?.toDouble() ?? totalPrice + vat;

  double get vat => totalPrice * (SharedPrefs.instance.appConfig?.vatValue ?? 0) / 100;

  factory Card.fromJson(Map<String, dynamic>  json) => Card(
    id: json["_id"],
    isSpecial: json["isSpecial"],
    color: json["color"] == null ? null : ColorModel.fromJson(json["color"]),
    proColor: json["proColor"] == null ? null : ProColor.fromJson(json["proColor"]),
    shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
    shapes: json["shapes"] == null ? null : List<CardShape>.from(json["shapes"].map((x) => CardShape.fromJson(x))),
    price: Price.fromJson(json["price"]),
    text: json["text"] == null ? null : CardText.fromJson(json["text"]),
    recipient: json["recipient"] == null ? null : Recipient.fromJson(json["recipient"]),
    isPaid: json["isPaid"],
    isDelivered: json["isDelivered"],
    receiveAt: json["receiveAt"] == null ? null : DateTime.parse(json["receiveAt"]).toLocal(),
    celebrateIcon: json["celebrateIcon"],
    celebrateQR: json["celebrateQR"],
    priceAfterDiscount: json["priceAfterDiscount"],
    discountCode: json["discountCode"] == null ? null : DiscountCode.fromJson(json["discountCode"]),
    paidAt: json["paidAt"] == null ? null : DateTime.parse(json["paidAt"]).toLocal(),
    autoReminderSent: json["autoReminderSent"],
    priority: json["priority"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isSpecial": isSpecial,
    "color": color?.toJson(),
    "proColor": proColor?.toJson(),
    "shop": shop?.toJson(),
    "shapes": shapes == null ? null : List<dynamic>.from(shapes!.map((x) => x.toJson())),
    "price": price?.toJson(),
    "text": text?.toJson(),
    "recipient": recipient?.toJson(),
    "isPaid": isPaid,
    "isDelivered": isDelivered,
    "receiveAt": receiveAt?.toUtc().toIso8601String(),
    "celebrateIcon": celebrateIcon,
    "celebrateQR": celebrateQR,
    "priceAfterDiscount": priceAfterDiscount,
    "discountCode": discountCode?.toJson(),
    "paidAt": paidAt?.toUtc().toIso8601String(),
    "autoReminderSent": autoReminderSent,
    "priority": priority,
  };

  Card copyWith({
    String? id,
    bool? isSpecial,
    ColorModel? color,
    ProColor? proColor,
    Shop? shop,
    List<CardShape>? shapes,
    Price? price,
    CardText? text,
    Recipient? recipient,
    bool? isPaid,
    bool? isDelivered,
    DateTime? receiveAt,
    String? celebrateIcon,
    String? celebrateQR,
    num? priceAfterDiscount,
    DiscountCode? discountCode,
    DateTime? paidAt,
    bool? autoReminderSent,
    num? priority,
  }) {
    return Card(
      id: id ?? this.id,
      isSpecial: isSpecial ?? this.isSpecial,
      color: color ?? this.color,
      proColor: proColor ?? this.proColor,
      shop: shop ?? this.shop,
      shapes: shapes ?? this.shapes,
      price: price ?? this.price,
      text: text ?? this.text,
      recipient: recipient ?? this.recipient,
      isPaid: isPaid ?? this.isPaid,
      isDelivered: isDelivered ?? this.isDelivered,
      receiveAt: receiveAt ?? this.receiveAt,
      celebrateIcon: celebrateIcon ?? this.celebrateIcon,
      celebrateQR: celebrateQR ?? this.celebrateQR,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      discountCode: discountCode ?? this.discountCode,
      paidAt: paidAt ?? this.paidAt,
      autoReminderSent: autoReminderSent ?? this.autoReminderSent,
      priority: priority ?? this.priority,
    );
  }
}

class DiscountCode {
  DiscountCode({
    this.isUsed,
    this.code,
    this.qrCode,
  });

  final bool? isUsed;
  final String? code;
  final String? qrCode;

  factory DiscountCode.fromJson(Map<String, dynamic> json) => DiscountCode(
    isUsed: json["isUsed"],
    code: json["code"],
    qrCode: json["qrCode"],
  );

  Map<String, dynamic> toJson() => {
    "isUsed": isUsed,
    "code": code,
    "qrCode": qrCode,
  };
}

class Price {
  Price({
    required this.value,
    this.fontFamily,
    this.fontSize,
    this.fontColor,
    this.fontWeight,
  });

  final num value;
  final String? fontFamily;
  final num? fontSize;
  final String? fontColor;
  final int? fontWeight;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    value: json["value"],
    fontFamily: json["fontFamily"],
    fontSize: json["fontSize"],
    fontColor: json["fontColor"],
    fontWeight: json["fontWeight"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "fontFamily": fontFamily,
    "fontSize": fontSize,
    "fontColor": fontColor,
    "fontWeight": fontWeight,
  };
}

class Recipient {
  Recipient({
    this.name,
    this.whatsappNumber,
  });

  final String? name;
  final String? whatsappNumber;

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
    name: json["name"],
    whatsappNumber: json["whatsappNumber"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "whatsappNumber": whatsappNumber,
  };
}

class CardText {
  CardText({
    required this.message,
    this.fontFamily,
    this.fontSize,
    this.fontColor,
    this.fontWeight,
    this.xPosition,
    this.yPosition,
  });

  final String? message;
  final String? fontFamily;
  final num? fontSize;
  final String? fontColor;
  final int? fontWeight;
  final num? xPosition;
  final num? yPosition;

  String? get fontFamilyAtr => fontFamily == null 
    ? null
    : RegExp(r"'?([\w\s]+)'?").firstMatch(fontFamily!)?.group(1);

  factory CardText.fromJson(Map<String, dynamic> json) => CardText(
    message: json["message"],
    fontFamily: json["fontFamily"],
    fontSize: json["fontSize"],
    fontColor: json["fontColor"],
    fontWeight: json["fontWeight"],
    xPosition: json["xPosition"]?.toDouble(),
    yPosition: json["yPosition"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "fontFamily": fontFamily,
    "fontSize": fontSize,
    "fontColor": fontColor,
    "fontWeight": fontWeight,
    "xPosition": xPosition,
    "yPosition": yPosition,
  };

  num? translateX({num width = 0, num height = 0}) {
    if (xPosition == null) return null;
    return xPosition! - width / 2;
  }

  // my_x = x    - width / 2
  // x    = my_x + width / 2

  num? translateY({num width = 0, num height = 0}) {
    if (yPosition == null) return null;
    return yPosition!;
  }

  Color get fontColorAtr => Color(int.parse('0xff$fontColor'.replaceAll(RegExp('#'), '')));
}