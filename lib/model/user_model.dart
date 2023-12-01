// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? id;
  String? nome;
  String? telefone;
  String? dtNascimento;
  String? username;
  String? senha;
  int? level;
  String? etapaCoord;

  UserModel({
    this.id,
    this.nome,
    this.telefone,
    this.dtNascimento,
    this.username = '',
    this.senha = '',
    this.level = 0,
    this.etapaCoord = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'dtNascimento': dtNascimento,
      'username': username,
      'senha': senha,
      'level': level,
      'etapaCoord': etapaCoord,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      nome: map['nome'] != null ? map['nome'] as String : null,
      telefone: map['telefone'] != null ? map['telefone'] as String : null,
      dtNascimento: map['dtNascimento'] != null ? map['dtNascimento'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      senha: map['senha'] != null ? map['senha'] as String : null,
      level: map['level'] != null ? map['level'] as int : null,
      etapaCoord: map['etapaCoord'] != null ? map['etapaCoord'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
