// {
//     "status": "success",
//     "data": [
//         {
//             "PaymentMethodId": 2,
//             "PaymentMethodAr": "فيزا / ماستر",
//             "PaymentMethodEn": "VISA/MASTER",
//             "ImageUrl": "https://sa.myfatoorah.com/imgs/payment-methods/vm.png"
//         },
//         {
//             "PaymentMethodId": 6,
//             "PaymentMethodAr": "مدى",
//             "PaymentMethodEn": "mada",
//             "ImageUrl": "https://sa.myfatoorah.com/imgs/payment-methods/md.png"
//         },
//         {
//             "PaymentMethodId": 11,
//             "PaymentMethodAr": "أبل باي",
//             "PaymentMethodEn": "Apple Pay",
//             "ImageUrl": "https://sa.myfatoorah.com/imgs/payment-methods/ap.png"
//         }
//     ]
// }

class PaymentMethod {
  final int paymentMethodId;
  final String paymentMethodAr;
  final String paymentMethodEn;
  final String imageUrl;

  PaymentMethod({
    required this.paymentMethodId,
    required this.paymentMethodAr,
    required this.paymentMethodEn,
    required this.imageUrl,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentMethodId: json['PaymentMethodId'],
      paymentMethodAr: json['PaymentMethodAr'],
      paymentMethodEn: json['PaymentMethodEn'],
      imageUrl: json['ImageUrl'],
    );
  }

  static List<PaymentMethod> fromJsonList(List<dynamic> json) {
    return json.map((e) => PaymentMethod.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'PaymentMethodId': paymentMethodId,
      'PaymentMethodAr': paymentMethodAr,
      'PaymentMethodEn': paymentMethodEn,
      'ImageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'PaymentMethod(paymentMethodId: $paymentMethodId, paymentMethodAr: $paymentMethodAr, paymentMethodEn: $paymentMethodEn, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PaymentMethod &&
      other.paymentMethodId == paymentMethodId &&
      other.paymentMethodAr == paymentMethodAr &&
      other.paymentMethodEn == paymentMethodEn &&
      other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return paymentMethodId.hashCode ^
      paymentMethodAr.hashCode ^
      paymentMethodEn.hashCode ^
      imageUrl.hashCode;
  }
}