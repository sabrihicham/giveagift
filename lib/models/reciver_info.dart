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