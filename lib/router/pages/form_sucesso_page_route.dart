import 'package:flutter/material.dart';
import 'package:webapp/pages/register/formulario_sucesso.dart';

class FormSucessoPageRoute extends Page {
  final VoidCallback onSubmit;
  const FormSucessoPageRoute({required this.onSubmit}) : super(key: const ValueKey('FormSucessoPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return FormularioSucesso(onSubmit: onSubmit);
      },
    );
  }
}