class ReadyCardsResponse {
  ReadyCardsResponse({
    required this.data,
    required this.totalPages,
    required this.currentPage,
  });

  final List<CardData> data;
  final int totalPages;
  final int currentPage;

  factory ReadyCardsResponse.fromJson(Map<String, dynamic> json) {
    return ReadyCardsResponse(
      data: List<CardData>.from(json['data'].map((x) => CardData.fromJson(x))),
      totalPages: json['totalPages'],
      currentPage: json['currentPage'] is String
        ? int.parse(json['currentPage'])
        : json['currentPage'],
    );
  }
}

class CardData {
  CardData({
    required this.id,
    required this.cardFront,
    required this.cardBack,
    required this.logoImage,
    required this.price,
    required this.brand,
  });

  final String id;
  final String cardFront;
  final String cardBack;
  final String logoImage;
  final String price;
  final String? brand;

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      id: json['_id'],
      cardFront: json['cardFront'],
      cardBack: json['cardBack'],
      logoImage: json['logoImage'],
      price: json['price'],
      brand: json['brand'],
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
    };
  }

  CardData copyWith({
    String? id,
    String? cardFront,
    String? cardBack,
    String? logoImage,
    String? price,
    String? brand,
  }) {
    return CardData(
      id: id ?? this.id,
      cardFront: cardFront ?? this.cardFront,
      cardBack: cardBack ?? this.cardBack,
      logoImage: logoImage ?? this.logoImage,
      price: price ?? this.price,
      brand: brand ?? this.brand,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CardData &&
      other.id == id &&
      other.cardFront == cardFront &&
      other.cardBack == cardBack &&
      other.logoImage == logoImage &&
      other.price == price &&
      other.brand == brand;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      cardFront.hashCode ^
      cardBack.hashCode ^
      logoImage.hashCode ^
      price.hashCode ^
      brand.hashCode;
  }

  @override
  String toString() {
    return 'CardData(id: $id, cardFront: $cardFront, cardBack: $cardBack, logoImage: $logoImage, price: $price, brand: $brand)';
  }
}