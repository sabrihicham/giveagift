/*
{
    "items": [
        {
            "cardFront": "https://i.imgur.com/1coH92P.jpg",
            "cardBack": "https://i.imgur.com/avoLpp3.jpg",
            "logoImage": "https://i.imgur.com/LbLvTY2.png",
            "price": 300,
            "brand": "ELCT",
            "receiverInfo": {
                "phone": "556646053",
                "name": "sarga"
            },
            "ready": true,
            "uniqueCode": "3e6bfb6624be",
            "codeUsed": false,
            "isCustom": false,
            "isPaid": false,
            "status": "active",
            "_id": "65c481a1e756c948e74358f2"
        }
    ],
    "_id": "662be9cea092630c118c7899",
    "__v": 0
}
*/

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

class ReceiverInfo {
  final String phone;
  final String name;

  ReceiverInfo({
    required this.phone,
    required this.name,
  });

  factory ReceiverInfo.fromJson(Map<String, dynamic> json) {
    return ReceiverInfo(
      phone: json['phone'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'name': name,
    };
  }
}