import 'package:flutter/material.dart';
import 'package:webapp/pages/login/login_page.dart';

class LoginPageRoute extends Page {
  // final VoidCallback onLogin;
  final VoidCallback onRegisterClick;
  const LoginPageRoute({required this.onRegisterClick}) : super(key: const ValueKey('LoginPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return LoginPage(onRegisterClick: onRegisterClick);
      },
    );
  }
}