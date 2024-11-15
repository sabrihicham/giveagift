import 'package:giveagift/models/reciver_info.dart';

class CustomCart {
  final String id;
  // final List<CustomCardData> items;

  CustomCart({
    required this.id,
    // required this.items,
  });

  factory CustomCart.fromJson(Map<String, dynamic> json) {
    return CustomCart(
      id: json['_id'],
      // items: List<CustomCardData>.from(json['items'].map((x) => CustomCardData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      // 'items': items.map((e) => e.toJson()).toList(),
    };
  }

}

class Cart {
  final String id;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['_id'],
      items: List<CartItem>.from(json['items'].map((x) => CartItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class CartItem {
  final String id;
  final String cardFront;
  final String cardBack;
  final String logoImage;
  final int price;
  final String brand;
  final ReceiverInfo receiverInfo;
  final bool? ready;
  final String? uniqueCode;
  final bool? codeUsed;
  final bool isCustom;
  final bool? isPaid;
  final String? status;

  CartItem({
    required this.id,
    required this.cardFront,
    required this.cardBack,
    required this.logoImage,
    required this.price,
    required this.brand,
    required this.receiverInfo,
    required this.ready,
    required this.uniqueCode,
    required this.codeUsed,
    required this.isCustom,
    required this.isPaid,
    required this.status,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'],
      cardFront: json['cardFront'],
      cardBack: json['cardBack'],
      logoImage: json['logoImage'],
      price: json['price'],
      brand: json['brand'],
      receiverInfo: ReceiverInfo.fromJson(json['receiverInfo']),
      ready: json['ready'],
      uniqueCode: json['uniqueCode'],
      codeUsed: json['codeUsed'],
      isCustom: json['isCustom'],
      isPaid: json['isPaid'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'cardFront': cardFront,
      'cardBack': cardBack,
      'logoImage': logoImage,
      'price': price,
      'brand': brand,
      'receiverInfo': receiverInfo.toJson(),
      'ready': ready,
      'uniqueCode': uniqueCode,
      'codeUsed': codeUsed,
      'isCustom': isCustom,
      'isPaid': isPaid,
      'status': status,
    };
  }
}