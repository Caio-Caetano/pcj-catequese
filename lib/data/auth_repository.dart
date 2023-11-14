import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/cache/preference.dart';
import 'package:webapp/model/user_model.dart';

const String authKey = 'AuthKey';

class AuthRepository {
  final Preference preference;

  AuthRepository(this.preference);

  Future<bool> isUserLoggedIn() async => await preference.getBool(authKey, defaultValue: false);

  Future<bool> _updateLoginStatus(UserModel? model) async {
    if (model != null) {
      return await _searchUser(model);
    } else { 
      return await preference.putBool(authKey, false);
    }
  }

  Future<bool> _searchUser(UserModel model) async {
    var users = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: model.username).get();
    if (users.docs.isEmpty) return false;
    var result = users.docs.first;
    if (result.get('username') == model.username && result.get('senha') == model.senha) {
      return await preference.putBool(authKey, true);
    }
    return false;
  }

  Future<bool> logout() => _updateLoginStatus(null);

  Future<bool> login(UserModel model) => _updateLoginStatus(model);
}
