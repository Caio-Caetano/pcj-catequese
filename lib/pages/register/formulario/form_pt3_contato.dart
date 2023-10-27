import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';
import 'package:webapp/viewmodels/inscricao_view_model.dart';

class FormularioContato extends StatelessWidget {
  const FormularioContato({super.key, required this.etapa, required this.onSubmit});

  final String etapa;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> key = GlobalKey<FormState>();

    final TextEditingController telefoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    var maskFormatter = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
    
    final inscricaoProvider = Provider.of<InscricaoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(etapa, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Wrap(
            runSpacing: 20,
            children: [
              TextFieldCustom(
                controller: telefoneController,
                labelText: 'Telefone:',
                formatter: [maskFormatter],
                iconPrefix: const Icon(Icons.phone),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '⚠️ Este campo é obrigatório.';
                  }
                  return null;
                },
                hintText: 'Digite o seu telefone (WhatsApp)*',
              ),
              TextFieldCustom(
                controller: emailController,
                labelText: 'E-mail:',
                iconPrefix: const Icon(Icons.email),
                hintText: 'Digite um e-mail para contato',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Verifique se pelo menos um dos campos foi preenchido
          if (key.currentState!.validate()) {
            inscricaoProvider.updateContato(
              emailController.text,
              maskFormatter.getUnmaskedText()
            );
            onSubmit();
          }
        },
        label: const Text('Avançar', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.forward),
      ),
    );
  }
}
