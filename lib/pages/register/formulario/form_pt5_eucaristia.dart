import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/model/checkbox_model.dart';
import 'package:webapp/viewmodels/inscricao_view_model.dart';

class FormularioEucaristia extends StatefulWidget {
  const FormularioEucaristia({super.key, required this.etapa, required this.onSubmit});

  final String etapa;
  final VoidCallback onSubmit;

  @override
  State<FormularioEucaristia> createState() => _FormularioEucaristiaState();
}

class _FormularioEucaristiaState extends State<FormularioEucaristia> {
  List<CheckBoxModel> itens = [];
  FilePickerResult? file;

  @override
  void initState() {
    super.initState();
    itens = [CheckBoxModel(id: 1, texto: 'Sim'), CheckBoxModel(id: 2, texto: 'Não')];
    if (widget.etapa == "Adultos") itens.add(CheckBoxModel(id: 3, texto: 'Não sei'));
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
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          const Text(
            'Você possui a 1º EUCARISTIA?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              itens.length,
              (index) => CheckboxListTile(
                title: Text(itens[index].texto, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                value: itens[index].checked,
                onChanged: (value) {
                  setState(() {
                    for (var element in itens) {
                      element.checked = false;
                    }
                    itens[index].checked = value!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (itens.first.checked)
            InkWell(
              onTap: () async {
                file = await FilePickerWeb.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpeg', 'jpg', 'png', 'pdf'],
                );
                if (file != null) {
                  setState(() {});
                }
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4), offset: const Offset(2, 2), blurRadius: 5)],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.file_upload, size: 35, color: Theme.of(context).colorScheme.primary),
                      Text('Envie o batistério', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
          if (file != null)
            InkWell(
                onTap: () => setState(() {
                      file = null;
                    }),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Text(file!.files.first.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Text('Clique para remover', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
                  ],
                ))
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (itens.first.checked && file != null) {
            // Salva com o arquivo
            inscricaoProvider.updateEucaristia({
              'possui': true,
              'arquivo': file!.files[0],
            });
            widget.onSubmit();
          } else if (itens.first.checked && file == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('É necessário selecionar o arquivo comprando seu batistério.', style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.yellow,
            ));
          } else {
            // Salva sem arquivo
            inscricaoProvider.updateEucaristia({
              'possui': false,
              'arquivo': null,
            });
            widget.onSubmit();
          }
        },
        label: const Text('Avançar', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.forward),
      ),
    );
  }
}
