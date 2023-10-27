import 'package:flutter/material.dart';
import 'package:webapp/pages/register/formulario/form_pt4_batismo.dart';

class FormBatismoPageRoute extends Page {
  final String? etapa;
  final VoidCallback onSubmit;
  const FormBatismoPageRoute({required this.onSubmit, this.etapa}) : super(key: const ValueKey('FormBatismoPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return FormularioBatismo(etapa: etapa ?? '', onSubmit: onSubmit);
      },
    );
  }
}