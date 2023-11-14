import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:webapp/model/user_model.dart';

class UserRepository {
  Future<String> userAdd(UserModel model) async {
    CollectionReference inscricoes = FirebaseFirestore.instance.collection('users');
    model.senha = _encryptPassword(model.senha!);
    String retorno = await inscricoes.add(model.toMap()).then((value) => value.id).catchError((error) => 'Não foi possível registrar o usuário >>> $error');
    return retorno;
  }
}

String _encryptPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
}