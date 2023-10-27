import 'package:flutter/material.dart';
import 'package:webapp/data/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository? authRepository;
  bool logingIn = false;
  bool logingOut = false;

  AuthViewModel(this.authRepository);

  Future<bool> login() async {
    logingIn = true;
    notifyListeners();
    final result = await authRepository!.login();
    logingIn = false;
    notifyListeners();
    return result;
  }

  Future<bool> logout() async {
    logingOut = true;
    notifyListeners();
    final logoutResult = await authRepository!.logout();
    logingOut = false;
    notifyListeners();
    return logoutResult;
  }
}