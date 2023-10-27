import 'package:flutter/material.dart';
import 'package:webapp/pages/register/formulario/form_pt5_eucaristia.dart';

class FormEucaristiaPageRoute extends Page {
  final String? etapa;
  final VoidCallback onSubmit;
  const FormEucaristiaPageRoute({required this.onSubmit, this.etapa}) : super(key: const ValueKey('FormEucaristiaPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return FormularioEucaristia(etapa: etapa ?? '', onSubmit: onSubmit);
      },
    );
  }
}