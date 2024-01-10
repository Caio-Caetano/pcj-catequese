import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/cache/preference.dart';
import 'package:crypto/crypto.dart';
import 'package:webapp/model/user_model.dart';

const String authKey = 'AuthKey';
const String authKeyString = 'AuthKeyString';
const String etapaCoordString = 'EtapaCoordString';
const String etapaString = 'EtapaString';
const String nomeString = 'NomeString';

class AuthRepository {
  final Preference preference;

  AuthRepository(this.preference);

  Future<bool> isUserLoggedIn() async => await preference.getBool(authKey, defaultValue: false);

  Future<int> getAccessLevel() async {
    final String accessLevelString = await preference.getString(authKeyString, defaultValue: '');
    final int accessLevel = int.tryParse(accessLevelString) ?? -1;
    return accessLevel;
  }

  Future<String> getEtapaCoord() async => await preference.getString(etapaCoordString, defaultValue: '');

  Future<String> getEtapa() async => await preference.getString(etapaString, defaultValue: '');

  Future<String> getNomeCatequista() async => await preference.getString(nomeString, defaultValue: '');

  Future<UserModel?> _updateLoginStatus(UserModel? model) async {
    if (model != null) {
      return await _searchUser(model);
    } else {
      await preference.putBool(authKey, false);
      await preference.putString(authKeyString, '');
      await preference.putString(etapaCoordString, '');
      await preference.putString(etapaString, '');
      await preference.putString(nomeString, '');
      return null;
    }
  }

  String _encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<UserModel?> _searchUser(UserModel model) async {
    var users = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: model.username).get();
    if (users.docs.isEmpty) return null;
    var result = users.docs.first;
    Map<String, dynamic> resultMap = result.data();
    if (result.get('username') == model.username && result.get('senha') == _encryptPassword(model.senha ?? '')) {
      await preference.putBool(authKey, true);
      await preference.putString(authKeyString, result.get('level').toString());
      if (resultMap['etapaCoord'] != null) await preference.putString(etapaCoordString, result.get('etapaCoord'));
      if (resultMap['etapa'] != null) await preference.putString(etapaString, result.get('etapa'));
      if (resultMap['nome'] != null) await preference.putString(nomeString, result.get('nome'));
      return UserModel(
        username: result.get('username'),
        level: result.get('level'),
        etapaCoord: result.get('etapaCoord'),
        etapa: result.get('etapa'),
        nome: result.get('nome'),
      );
    }
    return null;
  }

  Future<UserModel?> logout() => _updateLoginStatus(null);

  Future<UserModel?> login(UserModel model) => _updateLoginStatus(model);
}
