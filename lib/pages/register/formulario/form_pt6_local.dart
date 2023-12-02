import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/functions/upload_file.dart';
import 'package:webapp/providers/loading_notifier.dart';
import 'package:webapp/viewmodels/inscricao_view_model.dart';

class FormularioPrefLocal extends StatefulWidget {
  const FormularioPrefLocal({super.key, required this.etapa, required this.onSubmit});

  final String etapa;
  final Function(String) onSubmit;

  @override
  State<FormularioPrefLocal> createState() => _FormularioPrefLocalState();
}

class _FormularioPrefLocalState extends State<FormularioPrefLocal> {
  // TODO: A LISTA DOS LOCAIS E HORARIOS DOS ENCONTROS DEVERÁ SER ALTERADO PELO ADMIN.
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [];
    if (widget.etapa.contains('Eucaristia')) {
      // Terça ou Quinta 19h - Santuário
      // Sábado 9:30h - Santuário, Jd Portugal, Nsr Aparecida
      menuItems = [
        DropdownMenuItem(value: 'Terca 19h Santuario', child: Text('Terça-feira as 19h as 20:30h no Santuário', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Quinta 19h Santuario', child: Text('Quinta-feira as 19h as 20:30h no Santuário', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Sabado 9:30h Santuario', child: Text('Sábado as 9:30h as 11:00h no Santuário', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Sabado 9:30h Jd Portugal', child: Text('Sábado as 9:30h as 11:00h no Jd Portugal', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Sabado 9:30h Centro Past. Pe. Wagner', child: Text('Sábado as 9:30h as 11:00h na Centro Past. Pe. Wagner', style: Theme.of(context).textTheme.bodyMedium)),
      ];
    }

    if (widget.etapa.contains('Crisma')) {
      // Terça e Quinta 19h - Santuário
      // Sábado 8h - Santuário, Jd Portugal, Nsr Aparecida
      menuItems = [
        DropdownMenuItem(value: 'Terca 19h Santuario', child: Text('Terça-feira as 19h as 20:30h no Santuário', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Quinta 19h Santuario', child: Text('Quinta-feira as 19h as 20:30h no Santuário', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Sabado 8h Santuario', child: Text('Sábado as 8h as 9:30h no Santuário', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Sabado 8h Jd Portugal', child: Text('Sábado as 8h as 9:30h no Jd Portugal', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Sabado 8h Centro Past. Pe. Wagner', child: Text('Sábado as 8h as 9:30h na Centro Past. Pe. Wagner', style: Theme.of(context).textTheme.bodyMedium)),
      ];
    }

    if (widget.etapa == 'Jovens') {
      // Terça e Quinta 19h - Santuário
      // Sábado 8h - Santuário, Jd Portugal, Nsr Aparecida
      menuItems = [
        DropdownMenuItem(value: 'Terca 19h Santuario', child: Text('Terça-feira as 19h as 20:30h no Santuário', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Quinta 19h Santuario', child: Text('Quinta-feira as 19h as 20:30h no Santuário', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Sabado 8h Santuario', child: Text('Sábado as 8h as 9:30h no Santuário', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Sabado 8h Jd Portugal', child: Text('Sábado as 8h as 9:30h no Jd Portugal', style: Theme.of(context).textTheme.bodyMedium)),
        DropdownMenuItem(value: 'Sabado 8h Centro Past. Pe. Wagner', child: Text('Sábado as 8h as 9:30h na Centro Past. Pe. Wagner', style: Theme.of(context).textTheme.bodyMedium)),
      ];
    }
    return menuItems;
  }

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final dropdownFormKey = GlobalKey<FormState>();
    final inscricaoProvider = Provider.of<InscricaoProvider>(context);
    final loadingProvider = Provider.of<LoadingClass>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.etapa, style: const TextStyle(color: Colors.white)),
        ),
        body: widget.etapa != 'Adultos'
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: dropdownFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                              hintText: 'Selecione...',
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
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValue = newValue!;
                              });
                            },
                            items: dropdownItems),
                      ],
                    ),
                  ),
                ))
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
