import 'package:flutter/material.dart';
import 'package:webapp/pages/register/formulario/form_adicional_adulto.dart';

class FormAdultoAdicionalPageRoute extends Page {
  final String? etapa;
  final VoidCallback onSubmit;
  
  const FormAdultoAdicionalPageRoute({ required this.onSubmit, this.etapa}) : super(key: const ValueKey('FormAdicionalPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return FormAdicionalAdulto(etapa: etapa ?? '', onSubmit: onSubmit);
      },
    );
  }
}