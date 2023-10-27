import 'package:flutter/material.dart';
import 'package:webapp/enums.dart';
import 'package:webapp/pages/register/register_page_01.dart';

class RegisterPageRoute extends Page {
  final Function(Turma) onSubmit;
  final VoidCallback onClose;
  const RegisterPageRoute(this.onSubmit, this.onClose) : super(key: const ValueKey('RegisterPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return RegisterCatechized(onSubmit: onSubmit, onClose: onClose);
      },
    );
  }
}