import 'package:flutter/material.dart';
import 'package:webapp/data/auth_repository.dart';
import 'package:webapp/model/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository? authRepository;
  bool logingIn = false;
  bool logingOut = false;
  AuthViewModel(this.authRepository);

  Future<UserModel?> login(UserModel model) async {
    logingIn = true;
    notifyListeners();
    final result = await authRepository!.login(model);
    logingIn = false;
    notifyListeners();
    return result;
  }

  Future<UserModel?> logout() async {
    logingOut = true;
    notifyListeners();
    final logoutResult = await authRepository!.logout();
    logingOut = false;
    notifyListeners();
    return logoutResult;
  }
}
