import 'package:flutter/material.dart';
import 'package:webapp/pages/register/formulario/form_pt6_local.dart';

class FormLocalPageRoute extends Page {
  final String? etapa;
  final VoidCallback onSubmit;
  const FormLocalPageRoute({required this.onSubmit, this.etapa}) : super(key: const ValueKey('FormLocalPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return FormularioPrefLocal(etapa: etapa ?? '', onSubmit: onSubmit);
      },
    );
  }
}