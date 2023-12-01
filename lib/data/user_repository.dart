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

  Future<List<Map<String, dynamic>>> getUsers() async {
    List<Map<String, dynamic>> listaUsuarios = [];
    var usuarios = await FirebaseFirestore.instance.collection('users').get();
    for (var usuario in usuarios.docs) {
      Map<String, dynamic> usuarioData = usuario.data();
      usuarioData['id'] = usuario.id;
      listaUsuarios.add(usuarioData);
    }
    return listaUsuarios;
  }

  Future<void> editUsuario(UserModel model, String oldSenha) async {
    String senhaEncrypted = _encryptPassword(model.senha ?? '');
    if (oldSenha != senhaEncrypted && model.senha != null) {
      model.senha = senhaEncrypted;
    } else {
      model.senha = oldSenha;
    }
    await FirebaseFirestore.instance.collection('users').doc(model.id).update(model.toMap());
  }

  Future<bool> deleteUsuario(String id) async => await FirebaseFirestore.instance.collection('users').doc(id).delete().then((value) => true).catchError((error) => false);

}

String _encryptPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
}