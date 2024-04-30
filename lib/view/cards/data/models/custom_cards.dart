import 'package:giveagift/models/reciver_info.dart';

class CustomCardsResponse {
  CustomCardsResponse({
    required this.colors,
    required this.shapes,
    required this.logoWithoutBackgroundUrls,
  });

  final List<String?> colors;
  final List<String?> shapes;
  final List<String?> logoWithoutBackgroundUrls;

  factory CustomCardsResponse.fromJson(Map<String, dynamic> json) {
    return CustomCardsResponse(
      colors: List<String?>.from(json['colors'].map((x) => x)),
      shapes: List<String>.from(json['shapes'].map((x) => x)),
      logoWithoutBackgroundUrls: List<String?>.from(json['logoWithoutBackgroundUrls'].map((x) => x)),
    );
  }
}

class CustomCardData {
  CustomCardData({
    required this.color,
    required this.shape,
    required this.message,
    required this.textColor,
    required this.font,
    required this.price,
    required this.brand,
    required this.receiverInfo,
    required this.brandUrl,
    required this.ready,
    required this.uniqueCode,
    required this.codeUsed,
    required this.isCustom,
    required this.isPaid,
    required this.status,
    required this.id,
  });

  final String color;
  final String shape;
  final String message;
  final String textColor;
  final String font;
  final double price;
  final Brand brand;
  final ReceiverInfo receiverInfo;
  final String brandUrl;
  final bool? ready;
  final String? uniqueCode;
  final bool codeUsed;
  final bool isCustom;
  final bool? isPaid;
  final String status;
  final String id;

  factory CustomCardData.fromJson(Map<String, dynamic> json) {
    return CustomCardData(
      color: json['color'],
      shape: json['shape'],
      message: json['message'],
      textColor: json['textColor'],
      font: json['font'],
      price: json['price'],
      brand: Brand.fromJson(json['brand']),
      receiverInfo: ReceiverInfo.fromJson(json['receiverInfo']),
      brandUrl: json['brandUrl'],
      ready: json['ready'],
      uniqueCode: json['uniqueCode'],
      codeUsed: json['codeUsed'],
      isCustom: json['isCustom'],
      isPaid: json['isPaid'],
      status: json['status'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'shape': shape,
      'message': message,
      'textColor': textColor,
      'font': font,
      'price': price,
      'brand': brand.toJson(),
      'receiverInfo': receiverInfo.toJson(),
      'brandUrl': brandUrl,
      'ready': ready,
      'uniqueCode': uniqueCode,
      'codeUsed': codeUsed,
      'isCustom': isCustom,
      'isPaid': isPaid,
      'status': status,
      '_id': id,
    };
  }
}

class Brand {
  Brand({
    required this.logoName,
    required this.logoImage,
    required this.brandDescription,
    required this.logoWithoutBackground,
    required this.brandUrl,
    required this.id,
  });

  final String logoName;
  final String logoImage;
  final String brandDescription;
  final String logoWithoutBackground;
  final String brandUrl;
  final String id;

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      logoName: json['logoName'],
      logoImage: json['logoImage'],
      brandDescription: json['brandDescription'],
      logoWithoutBackground: json['logoWithoutBackground'],
      brandUrl: json['brandUrl'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logoName': logoName,
      'logoImage': logoImage,
      'brandDescription': brandDescription,
      'logoWithoutBackground': logoWithoutBackground,
      'brandUrl': brandUrl,
      '_id': id,
    };
  }
}
