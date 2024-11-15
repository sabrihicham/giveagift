class SignUpResponse {
  String? status;
  String? message;
  String? token;
  String? userId;

  SignUpResponse({this.status, this.message, this.token, this.userId});

  SignUpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    data['userId'] = userId;
    return data;
  }
}