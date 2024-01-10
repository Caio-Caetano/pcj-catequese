import 'package:flutter/material.dart';
import 'package:webapp/pages/register/formulario_fechado.dart';

class FormFechadoPageRoute extends Page {
  final VoidCallback onSubmit;
  final String etapa;
  const FormFechadoPageRoute({required this.onSubmit, required this.etapa}) : super(key: const ValueKey('FormFechadoPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return FormularioFechado(onSubmit: onSubmit, etapa: etapa);
      },
    );
  }
}