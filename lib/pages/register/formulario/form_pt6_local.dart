import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/viewmodels/inscricao_view_model.dart';

class FormularioPrefLocal extends StatefulWidget {
  const FormularioPrefLocal({super.key, required this.etapa, required this.onSubmit});

  final String etapa;
  final VoidCallback onSubmit;

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
        const DropdownMenuItem(value: 'Terca 19h Santuario', child: Text('Terça-feira as 19h no Santuário')),
        const DropdownMenuItem(value: 'Quinta 19h Santuario', child: Text('Quinta-feira as 19h no Santuário')),
        const DropdownMenuItem(value: 'Sabado 09:30h Santuario', child: Text('Sábado as 09:30h no Santuário')),
        const DropdownMenuItem(value: 'Sabado 09:30h Jd Portugal', child: Text('Sábado as 09:30h no Jd Portugal')),
        const DropdownMenuItem(value: 'Sabado 09:30h Nossa Senhora Aparecida', child: Text('Sábado as 09:30h na Nossa Senhora Aparecida')),
      ];
    }

    if (widget.etapa.contains('Crisma')) {
      // Terça e Quinta 19h - Santuário
      // Sábado 8h - Santuário, Jd Portugal, Nsr Aparecida
      menuItems = [
        const DropdownMenuItem(value: 'Terca 19h Santuario', child: Text('Terça-feira as 19h no Santuário')),
        const DropdownMenuItem(value: 'Quinta 19h Santuario', child: Text('Quinta-feira as 19h no Santuário')),
        const DropdownMenuItem(value: 'Sabado 08h Santuario', child: Text('Sábado as 08h no Santuário')),
        const DropdownMenuItem(value: 'Sabado 08h Jd Portugal', child: Text('Sábado as 08h no Jd Portugal')),
        const DropdownMenuItem(value: 'Sabado 08h Nossa Senhora Aparecida', child: Text('Sábado as 08h na Nossa Senhora Aparecida')),
      ];
    }

    if (widget.etapa == 'Jovens') {
      // Terça e Quinta 19h - Santuário
      // Sábado 8h - Santuário, Jd Portugal, Nsr Aparecida
      menuItems = [
        const DropdownMenuItem(value: 'Terca 19h Santuario', child: Text('Terça-feira as 19h no Santuário')),
        const DropdownMenuItem(value: 'Quinta 19h Santuario', child: Text('Quinta-feira as 19h no Santuário')),
        const DropdownMenuItem(value: 'Sabado 08h Santuario', child: Text('Sábado as 08h no Santuário')),
        const DropdownMenuItem(value: 'Sabado 08h Jd Portugal', child: Text('Sábado as 08h no Jd Portugal')),
        const DropdownMenuItem(value: 'Sabado 08h Nossa Senhora Aparecida', child: Text('Sábado as 08h na Nossa Senhora Aparecida')),
      ];
    }
    return menuItems;
  }

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final dropdownFormKey = GlobalKey<FormState>();
    final inscricaoProvider = Provider.of<InscricaoProvider>(context);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (dropdownFormKey.currentState!.validate()) {
            inscricaoProvider.updateLocal(selectedValue);
            widget.onSubmit();
          }
        },
        label: const Text('Avançar', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.forward),
      ),
    );
  }
}
