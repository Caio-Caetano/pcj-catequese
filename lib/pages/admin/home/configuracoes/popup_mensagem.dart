import 'package:flutter/material.dart';
import 'package:webapp/controller/config_controller.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';

class PopUpMensagemFechado extends StatelessWidget {
  const PopUpMensagemFechado({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController mensagemController = TextEditingController();
    final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    final ConfigController configController = ConfigController();
    return AlertDialog(
      title: const Text('Editar mensagem'),
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: keyForm,
          child: SizedBox(
            width: 200,
            child: TextFieldCustom(
              controller: mensagemController,
              maxLines: 8,
              labelText: 'Nova mensagem',
              validator: (value) => value == null || value.isEmpty ? '⚠️ Campo obrigatório' : null,
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (keyForm.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                behavior: SnackBarBehavior.floating,
                elevation: 8,
                content: Text('Carregando...'),
              ));
              await configController.updateMensagemFechado(mensagemController.text.trim()).then((value) => Navigator.pop(context));
            }
          },
          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
          child: const Text('Editar', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}
