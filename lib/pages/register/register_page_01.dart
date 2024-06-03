import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:webapp/enums.dart';
import 'package:webapp/functions/classes/separete.dart';
import 'package:webapp/functions/validators/date_validator.dart';
import 'package:webapp/model/inscricao_model.dart';
import 'package:webapp/pages/widgets/appbar_custom.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';
import 'package:webapp/viewmodels/inscricao_view_model.dart';

class RegisterCatechized extends StatelessWidget {
  const RegisterCatechized({super.key, required this.onSubmit, required this.onClose});

  final Function(Turma) onSubmit;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    var maskFormatter = MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

    final inscricaoProvider = Provider.of<InscricaoProvider>(context);

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: appBarCustom(
        'Inscrição - PCJ',
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: InkWell(
            hoverColor: Colors.transparent,
            onTap: onClose,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.black),
                SizedBox(width: 5.0),
                Text('Voltar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Digite a data de nascimento:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                TextFieldCustom(
                  controller: controller,
                  validator: (value) => checkDate(maskFormatter.getMaskedText()),
                  formatter: [maskFormatter],
                ),
                const Text('Para pessoas batizadas é obrigatório anexar o Batistério ao final da inscrição',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            var age = separeteByAge(maskFormatter.getMaskedText());
            if (age['etapa'] != Turma.erro) {
              inscricaoProvider.updateNascimento(InscricaoModel()
                ..dataNascimento = maskFormatter.getMaskedText()
                ..idade = age['idade'].toString());
              inscricaoProvider.updateDtInscricao(DateTime.now().toString());
              onSubmit(age['etapa']);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.yellow,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  content: Text('⚠️ Entre em contato com a coordenação. Idade inválida.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                ),
              );
            }
          }
        },
        label: const Text('Avançar', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.forward),
        tooltip: 'Avançar',
      ),
    );
  }
}
