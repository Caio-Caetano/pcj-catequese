import 'package:flutter/material.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';

Widget editDialog(VoidCallback back) {
  return AlertDialog(
    title: const Text('Editar a inscrição'),
    content: Column(
      children: [
        TextFieldCustom(
          controller: TextEditingController(),
        ),
      ],
    ),
    actions: [
      ElevatedButton(onPressed: () => back(), child: const Text('Cancelar')),
    ],
  );
}
