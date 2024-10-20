import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/controller/horarios_locais_controller.dart';
import 'package:webapp/data/horarios_locais_repository.dart';
import 'package:webapp/functions/upload_file.dart';
import 'package:webapp/providers/loading_notifier.dart';
import 'package:webapp/viewmodels/inscricao_view_model.dart';

import '../../widgets/stepper.dart';

class FormularioPrefLocal extends StatefulWidget {
  const FormularioPrefLocal({super.key, required this.etapa, required this.onSubmit});

  final String etapa;
  final Function(String) onSubmit;

  @override
  State<FormularioPrefLocal> createState() => _FormularioPrefLocalState();
}

class _FormularioPrefLocalState extends State<FormularioPrefLocal> {
  final HorariosLocaisController horariosLocaisController = HorariosLocaisController(HorariosLocaisRepository());

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final dropdownFormKey = GlobalKey<FormState>();
    final inscricaoProvider = Provider.of<InscricaoProvider>(context);
    final loadingProvider = Provider.of<LoadingClass>(context);
    String etapaCut = widget.etapa.contains('-') ? widget.etapa.split(' ').last : widget.etapa;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.etapa, style: const TextStyle(color: Colors.white)),
        ),
        body: widget.etapa != 'Adultos'
            ? FutureBuilder(
                future: horariosLocaisController.getHorariosLocais(etapaCut.toLowerCase()),
                builder: (context, snapshot) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: dropdownFormKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const StepperInscricao(step: 5),
                              const Text(
                                'Selecione o local de sua PREFERÊNCIA:',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                'Lembrando: O local selecionado poderá ser alterado pela coordenação',
                                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                              DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    hintText: snapshot.connectionState == ConnectionState.waiting ? 'Carregando...' : 'Selecione...',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[600]!, width: 2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[600]!, width: 2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[400],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  validator: (value) => value == null ? "⚠️ É necessário escolher uma opção." : null,
                                  dropdownColor: Colors.grey[400],
                                  value: selectedValue,
                                  onChanged: (dynamic newValue) {
                                    setState(() {
                                      selectedValue = newValue!;
                                    });
                                  },
                                  items: snapshot.data == null ? [] : snapshot.data!.map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList()),
                            ],
                          ),
                        ),
                      ));
                },
              )
            : const Center(
                child: Text(
                  'O seu local e horário de encontro será informado pela coordenação.',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
        floatingActionButton: loadingProvider.loading
            ? FloatingActionButton.extended(label: const Text('Carregando...'), onPressed: () {})
            : FloatingActionButton.extended(
                onPressed: () async {
                  if (dropdownFormKey.currentState == null || dropdownFormKey.currentState!.validate()) {
                    inscricaoProvider.updateLocal(selectedValue);
                    inscricaoProvider.updateEtapa(widget.etapa);

                    loadingProvider.setLoading();

                    if (inscricaoProvider.inscricaoInfo.batismo != null) {
                      final fileBatismo = inscricaoProvider.inscricaoInfo.batismo!['arquivo'];
                      if (fileBatismo != null) {
                        String? urlBatismo = await UploadFile().upload(inscricaoProvider.inscricaoInfo.nome ?? '', fileBatismo, 'batismo', widget.etapa);
                        inscricaoProvider.updateBatismo({'arquivo': urlBatismo, 'possui': true});
                      }
                    }

                    if (inscricaoProvider.inscricaoInfo.eucaristia != null) {
                      final fileEucaristia = inscricaoProvider.inscricaoInfo.eucaristia!['arquivo'];
                      if (fileEucaristia != null) {
                        String? urlEucaristia = await UploadFile().upload(inscricaoProvider.inscricaoInfo.nome ?? '', fileEucaristia, 'eucaristia', widget.etapa);
                        inscricaoProvider.updateEucaristia({'arquivo': urlEucaristia, 'possui': true});
                      }
                    }

                    loadingProvider.setLoading();

                    final Map<String, dynamic> response = await loadingProvider.addInscricao(inscricaoProvider.inscricaoInfo);
                    final String responseMessage = response['message'];
                    if (response['sucesso']) {
                      widget.onSubmit(response['message']);
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.yellow,
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                          content: Text('⚠️ $responseMessage', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                        ),
                      );
                    }
                  }
                },
                label: const Text('Avançar', style: TextStyle(fontWeight: FontWeight.bold)),
                icon: const Icon(Icons.forward),
              ));
  }
}
