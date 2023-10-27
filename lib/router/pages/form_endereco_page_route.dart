import 'package:flutter/material.dart';
import 'package:webapp/pages/register/formulario/form_pt2_endereco.dart';

class FormEnderecoPageRoute extends Page {
  final String? etapa;
  final VoidCallback onSubmit;
  const FormEnderecoPageRoute({required this.onSubmit, this.etapa}) : super(key: const ValueKey('FormEnderecoPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return FormularioEndereco(etapa: etapa ?? '', onSubmit: onSubmit);
      },
    );
  }
}