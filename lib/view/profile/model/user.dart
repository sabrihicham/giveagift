class UserModel {
  int id;
  String name;
  String lastname;
  String email;
  String phone;
  double balance;
  bool isEmailVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.balance,
    required this.isEmailVerified,
  });
}