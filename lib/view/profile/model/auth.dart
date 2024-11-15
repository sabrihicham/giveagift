import 'package:giveagift/view/profile/model/user.dart';

class AuthResponse {
  AuthResponse({
    required this.status,
    required this.token,
    required this.data,
  });

  final String status;
  final String token;
  final Data data;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        status: json["status"],
        token: json["token"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "token": token,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.user,
  });

  final User user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}

