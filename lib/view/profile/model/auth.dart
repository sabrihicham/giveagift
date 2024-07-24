class AuthResponse {
  final String token;
  final String? error;

  AuthResponse({required this.token, this.error});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      error: json['error'],
    );
  }
}