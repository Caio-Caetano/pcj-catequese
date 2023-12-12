import 'package:flutter/material.dart';

class DropdownCatequista extends StatefulWidget {
  const DropdownCatequista({super.key, required this.etapa, required this.retornoEtapa});
  final String etapa;
  final ValueNotifier<String> retornoEtapa;

  @override
  State<DropdownCatequista> createState() => _DropdownCatequistaState();
}

class _DropdownCatequistaState extends State<DropdownCatequista> {
  String? etapa;

  List<DropdownMenuItem<String>> etapaMenu = [];

  @override
  Widget build(BuildContext context) {
    etapaMenu.clear();

    if (widget.etapa != 'Jovens' && widget.etapa != 'Adultos') {
      etapaMenu.addAll([
        DropdownMenuItem(value: '1º Etapa', child: Text('1º Etapa - ${widget.etapa}', style: const TextStyle(fontSize: 14))),
        DropdownMenuItem(value: '2º Etapa', child: Text('2º Etapa - ${widget.etapa}', style: const TextStyle(fontSize: 14))),
        DropdownMenuItem(value: '3º Etapa', child: Text('3º Etapa - ${widget.etapa}', style: const TextStyle(fontSize: 14))),
      ]);
    } else {
      etapaMenu.add(
        DropdownMenuItem(value: widget.etapa, child: Text(widget.etapa, style: const TextStyle(fontSize: 14))),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('Qual a turma', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
        DropdownButtonFormField(
            decoration: InputDecoration(
              hintText: 'Selecione...',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            borderRadius: BorderRadius.circular(20),
            validator: (value) => value == null ? "⚠️ É necessário escolher uma opção." : null,
            dropdownColor: Colors.grey[400],
            value: etapa,
            onChanged: (String? newValue) {
              setState(() {
                etapa = newValue!;
                widget.retornoEtapa.value = newValue;
              });
            },
            items: etapaMenu),
      ],
    );
  }
}
