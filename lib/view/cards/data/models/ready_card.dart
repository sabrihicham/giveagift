/*
  Create ReadyCardsSource class 

  {
    "data": [
        {
            "_id": "65c4829ce756c948e74358fa",
            "cardFront": "https://i.imgur.com/qGc9g0v.jpg",
            "cardBack": "https://i.imgur.com/3QGEfY1.jpg",
            "logoImage": "https://i.imgur.com/NY2hOTY.png",
            "price": "100",
            "__v": 0,
            "brand": "RUMORS"
        },
        {
            "_id": "65c483e3e756c948e7435902",
            "cardFront": "https://i.imgur.com/u4VPUkW.jpg",
            "cardBack": "https://i.imgur.com/vpR549f.jpg",
            "logoImage": "https://i.imgur.com/0LRUe5C.png",
            "price": "100",
            "__v": 0,
            "brand": "CROWD"
        },
        {
            "_id": "65f902868dce4075eebba6b0",
            "cardFront": "https://i.imgur.com/5jIWqJJ.jpg",
            "cardBack": "https://i.imgur.com/XW3vkUu.jpg",
            "logoImage": "https://i.imgur.com/zq0KcCO.png",
            "price": "100",
            "brandUrl": "https://hazel.com.sa/",
            "__v": 0,
            "brand": "HEZEL"
        }
    ],
    "totalPages": 1,
    "currentPage": "1"
  }
  */

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
      currentPage: json['currentPage'],
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
  final String brand;

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
}