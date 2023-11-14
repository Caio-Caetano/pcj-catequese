// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? username;
  String? senha;
  int? level;

  UserModel({
    this.username = '',
    this.senha = '',
    this.level = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'senha': senha,
      'level': level,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] != null ? map['username'] as String : null,
      senha: map['senha'] != null ? map['senha'] as String : null,
      level: map['level'] != null ? map['level'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
