import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/model/checkbox_model.dart';
import 'package:webapp/pages/widgets/stepper.dart';
import 'package:webapp/viewmodels/inscricao_view_model.dart';

class FormAdicionalAdulto extends StatefulWidget {
  const FormAdicionalAdulto(
      {super.key, required this.etapa, required this.onSubmit});

  final String etapa;
  final VoidCallback onSubmit;

  @override
  State<FormAdicionalAdulto> createState() => _FormAdicionalAdultoState();
}

class _FormAdicionalAdultoState extends State<FormAdicionalAdulto> {
  final dropdownFormKey = GlobalKey<FormState>();
  String? selectedValue;
  List<CheckBoxModel> itemsCheckbox = [];

  List<DropdownMenuItem<String>> items = const [
    DropdownMenuItem<String>(
        value: 'Casado no civil e religioso',
        child: Text('Casado no civil e religioso',
            style: TextStyle(fontSize: 14))),
    DropdownMenuItem<String>(
        value: 'Solteiro',
        child: Text('Solteiro', style: TextStyle(fontSize: 14))),
    DropdownMenuItem<String>(
        value: 'Casado no civil',
        child: Text('Casado no civil*', style: TextStyle(fontSize: 14))),
    DropdownMenuItem<String>(
        value: 'União estável reconhecida',
        child:
            Text('União estável reconhecida*', style: TextStyle(fontSize: 14))),
    DropdownMenuItem<String>(
        value: 'União estável não reconhecida',
        child: Text('União estável não reconhecida*',
            style: TextStyle(fontSize: 14))),
    DropdownMenuItem<String>(
        value: 'Divorciado ou Separado',
        child: Text('Divorciado ou Separado*', style: TextStyle(fontSize: 14))),
    DropdownMenuItem<String>(
        value: 'Segunda união',
        child: Text('Segunda união*', style: TextStyle(fontSize: 14))),
  ];

  @override
  void initState() {
    super.initState();
    itemsCheckbox = [CheckBoxModel(id: 1, texto: 'Sim'), CheckBoxModel(id: 2, texto: 'Não')];
  }

  @override
  Widget build(BuildContext context) {
    final inscricaoProvider = Provider.of<InscricaoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.etapa, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: dropdownFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const StepperInscricao(step: 6),
                const Text(
                  'Estado civil:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: 'Selecione...',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[600]!, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[600]!, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.grey[400],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  validator: (value) => value == null
                      ? "⚠️ É necessário escolher uma opção."
                      : null,
                  dropdownColor: Colors.grey[400],
                  value: selectedValue,
                  onChanged: (dynamic newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: items,
                ),
                const Text(
                  '*Devem estar dispostos a regularizar o casamento no religioso, se assim for possível. Caso tenham interesse, agende na secretaria para conversar com um dos nossos diáconos. Em caso de segunda união podem ver com o diácono a possibilidade de abrir o processo para pedir a nulidadade da primeira união.',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tem interesse no casamento comuinitário, feito na paróquia?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    itemsCheckbox.length,
                    (index) => CheckboxListTile(
                      title: Text(itemsCheckbox[index].texto,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      value: itemsCheckbox[index].checked,
                      onChanged: (value) {
                        setState(() {
                          for (var element in itemsCheckbox) {
                            element.checked = false;
                          }
                          itemsCheckbox[index].checked = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (dropdownFormKey.currentState == null ||
              dropdownFormKey.currentState!.validate()) {
            inscricaoProvider.updateAdicionalAdulto({
              'estado-civil': selectedValue,
              'casamento-paroquia': itemsCheckbox.first.checked ? 'Sim' : 'Não'
            });
            widget.onSubmit();
          }
        },
        label: const Text('Avançar',
            style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.forward),
      ),
    );
  }
}
