class User {
  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.photo,
    this.role,
    this.phoneVerified,
    this.v,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? photo;
  final String? role;
  final bool? phoneVerified;
  final int? v;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        photo: json["photo"],
        role: json["role"],
        phoneVerified: json["phoneVerified"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "photo": photo,
        "role": role,
        "phoneVerified": phoneVerified,
        "__v": v,
      };

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photo,
    String? role,
    bool? phoneVerified,
    int? v,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      role: role ?? this.role,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      v: v ?? this.v,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, photo: $photo, role: $role, phoneVerified: $phoneVerified, v: $v)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.photo == photo &&
        other.role == role &&
        other.phoneVerified == phoneVerified &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        photo.hashCode ^
        role.hashCode ^
        phoneVerified.hashCode ^
        v.hashCode;
  }
}
