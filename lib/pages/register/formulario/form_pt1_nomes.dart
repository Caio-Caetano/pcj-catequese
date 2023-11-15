import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/model/inscricao_model.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';
import 'package:webapp/viewmodels/inscricao_view_model.dart';

class FormularioNomes extends StatelessWidget {
  const FormularioNomes({super.key, required this.etapa, required this.onSubmit});

  final String etapa;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> key = GlobalKey<FormState>();

    final TextEditingController nomeController = TextEditingController();
    final TextEditingController nomeMaeController = TextEditingController();
    final TextEditingController nomePaiController = TextEditingController();
    final TextEditingController nomeResponsavelController = TextEditingController();

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
                controller: nomeController,
                labelText: 'Nome:',
                iconPrefix: const Icon(Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '⚠️ Este campo é obrigatório.';
                  }
                  return null;
                },
                hintText: 'Digite o nome*',
              ),
              TextFieldCustom(
                controller: nomeMaeController,
                labelText: 'Nome da mãe:',
                iconPrefix: const Icon(Icons.person),
                hintText: 'Digite o da mãe',
              ),
              TextFieldCustom(
                controller: nomePaiController,
                labelText: 'Nome do pai:',
                iconPrefix: const Icon(Icons.person),
                hintText: 'Digite o do pai',
              ),
              TextFieldCustom(
                controller: nomeResponsavelController,
                labelText: 'Nome do Responsável:',
                iconPrefix: const Icon(Icons.person),
                hintText: 'Digite o nome do responsável',
              ),
              const Text(
                'É necessário o preenchimento de pelo menos um nome de responsável. Mãe, Pai ou Outro.',
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Verifique se pelo menos um dos campos foi preenchido
          if (nomeResponsavelController.text.isNotEmpty || nomeMaeController.text.isNotEmpty || nomePaiController.text.isNotEmpty) {
            if (key.currentState!.validate()) {
              inscricaoProvider.updateNomes(InscricaoModel()
                ..nome = nomeController.text.toLowerCase()
                ..nomeMae = nomeMaeController.text
                ..nomePai = nomePaiController.text
                ..nomeResponsavel = nomeResponsavelController.text);
              onSubmit();
            }
          } else {
            // Exiba uma mensagem de erro se nenhum campo foi preenchido
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.yellow,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                content: Text('⚠️ Pelo menos um nome de responsável deve ser preenchido.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
              ),
            );
          }
        },
        label: const Text('Avançar', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.forward),
      ),
    );
  }
}
