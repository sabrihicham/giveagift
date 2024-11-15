class Wallet {
  Wallet({
    required this.id,
    required this.user,
    required this.balance,
    this.transfers = const [],
    required this.v,
  });

  final String id;
  final String user;
  final num balance;
  final List<Transfer> transfers;
  final int v;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
      id: json["_id"],
      user: json["user"],
      balance: json["balance"],
      transfers: List<Transfer>.from(json["transfers"].map((x) => Transfer.fromJson(x))),
      v: json["__v"],
    );

  Map<String, dynamic> toJson() => {
      "_id": id,
      "user": user,
      "balance": balance,
      "transfers": List<dynamic>.from(transfers.map((x) => x.toJson())),
      "__v": v,
    };

  Wallet copyWith({
    String? id,
    String? user,
    num? balance,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Wallet(
      id: id ?? this.id,
      user: user ?? this.user,
      balance: balance ?? this.balance,
      v: v ?? this.v,
    );
  }

  @override
  String toString() {
    return 'Wallet(id: $id, user: $user, balance: $balance, v: $v)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Wallet &&
      other.id == id &&
      other.user == user &&
      other.balance == balance &&
      other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user.hashCode ^
      balance.hashCode ^
      v.hashCode;
  }
}

class Transfer {
  Transfer({
    required this.id,
    required this.amount,
    required this.receiverName,
    required this.receiverPhone,
    required this.createdAt,
  });

  final String id;
  final num amount;
  final String receiverName;
  final String receiverPhone;
  final DateTime createdAt;

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
        id: json["_id"],
        amount: json["amount"],
        receiverName: json["receiverName"],
        receiverPhone: json["receiverPhone"],
        createdAt: DateTime.parse(json["createdAt"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "amount": amount,
        "receiverName": receiverName,
        "receiverPhone": receiverPhone,
        "createdAt": createdAt.toUtc(),
      };

  Transfer copyWith({
    String? id,
    num? amount,
    String? receiverName,
    String? receiverPhone,
    DateTime? createdAt,
  }) {
    return Transfer(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Transfer(id: $id, amount: $amount, receiverName: $receiverName, receiverPhone: $receiverPhone, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Transfer &&
      other.id == id &&
      other.amount == amount &&
      other.receiverName == receiverName &&
      other.receiverPhone == receiverPhone &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      amount.hashCode ^
      receiverName.hashCode ^
      receiverPhone.hashCode ^
      createdAt.hashCode;
  }
}