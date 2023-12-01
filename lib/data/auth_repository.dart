import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/cache/preference.dart';
import 'package:crypto/crypto.dart';
import 'package:webapp/model/user_model.dart';

const String authKey = 'AuthKey';
const String authKeyString = 'AuthKeyString';
const String etapaCoordString = 'EtapaCoordString';

class AuthRepository {
  final Preference preference;

  AuthRepository(this.preference);

  Future<bool> isUserLoggedIn() async => await preference.getBool(authKey, defaultValue: false);

  Future<int> getAccessLevel() async {
    final String accessLevelString = await preference.getString(authKeyString, defaultValue: '');
    final int accessLevel = int.parse(accessLevelString);
    return accessLevel;
  }

  Future<String> getEtapa() async => await preference.getString(etapaCoordString, defaultValue: '');

  Future<UserModel?> _updateLoginStatus(UserModel? model) async {
    if (model != null) {
      return await _searchUser(model);
    } else {
      await preference.putBool(authKey, false);
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
    if (result.get('username') == model.username && result.get('senha') == _encryptPassword(model.senha ?? '')) {
      await preference.putBool(authKey, true);
      await preference.putString(authKeyString, result.get('level').toString());
      await preference.putString(etapaCoordString, result.get('etapaCoord'));
      return UserModel(
        username: result.get('username'),
        level: result.get('level'),
        etapaCoord: result.get('etapaCoord'),
      );
    }
    return null;
  }

  Future<UserModel?> logout() => _updateLoginStatus(null);

  Future<UserModel?> login(UserModel model) => _updateLoginStatus(model);
}
