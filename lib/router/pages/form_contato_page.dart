import 'package:flutter/material.dart';
import 'package:webapp/pages/register/formulario/form_pt3_contato.dart';

class FormContatoPageRoute extends Page {
  final String? etapa;
  final VoidCallback onSubmit;
  const FormContatoPageRoute({required this.onSubmit, this.etapa}) : super(key: const ValueKey('FormContatoPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return FormularioContato(etapa: etapa ?? '', onSubmit: onSubmit);
      },
    );
  }
}