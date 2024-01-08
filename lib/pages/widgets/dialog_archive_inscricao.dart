import 'package:flutter/material.dart';
import 'package:webapp/pages/widgets/button_custom.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';

class DialogArchiveInscricao extends StatelessWidget {
  final String nome;
  final Function(String) onSubmit;
  final bool archiving;
  const DialogArchiveInscricao({super.key, required this.nome, required this.onSubmit, this.archiving = true});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    return AlertDialog(
      title: Text('${archiving ? 'Arquivar' : 'Restaurar'} a inscrição'),
      content: Form(
        key: keyForm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Você está prestes a ${archiving ? 'arquivar' : 'restaurar'} a inscrição do $nome. Descreva o motivo:'),
            TextFieldCustom(
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Necessário o preenchimento.';
                return null;
              },
              maxLines: 5,
              hintText: 'Motivo...',
            ),
            ButtonCustom(
                textButton: archiving ? 'Arquivar' : 'Restaurar',
                onTap: () {
                  if (keyForm.currentState!.validate()) {
                    onSubmit(controller.text);
                  }
                },
                icon: archiving ? Icons.archive_outlined : Icons.unarchive_outlined)
          ],
        ),
      ),
    );
  }
}
