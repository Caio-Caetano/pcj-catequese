import 'package:flutter/material.dart';
import 'package:webapp/pages/register/formulario/form_pt1_nomes.dart';

class FormNomesPageRoute extends Page {
  final String etapa;
  final VoidCallback onSubmit;
  const FormNomesPageRoute({required this.etapa, required this.onSubmit}) : super(key: const ValueKey('FormNomesPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return FormularioNomes(etapa: etapa.toString(), onSubmit: onSubmit);
      },
    );
  }
}