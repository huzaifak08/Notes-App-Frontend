import 'dart:convert';

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? token;
  final String? password;

  UserModel({this.id, this.name, this.email, this.token, this.password});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["_id"],
      name: map["name"],
      email: map["email"],
      token: map["token"],
      password: map["password"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "token": token,
      "password": password,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source));
}
