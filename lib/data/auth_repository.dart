import 'package:common/cache/preference.dart';

const String _Auth_Key = 'AuthKey';

class AuthRepository {
  final Preference preference;

  AuthRepository(this.preference);

  Future<bool> isUserLoggedIn() async => Future.delayed(const Duration(seconds: 2)).then((value) {
        return preference.getBool(_Auth_Key, defaultValue: false);
      });

  Future<bool> _updateLoginStatus(bool loggedIn) =>
      Future.delayed(const Duration(seconds: 2)).then((value) {
        return preference.putBool(_Auth_Key, loggedIn);
      });

  Future<bool> logout() => _updateLoginStatus(false);

  Future<bool> login() => _updateLoginStatus(true);
}