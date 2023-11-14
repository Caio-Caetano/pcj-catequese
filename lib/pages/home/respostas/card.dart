import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget cardResposta({required Map etapa}) {
  
  String inputDtInscricao = etapa['dataInscricao'];
  DateTime dateTime = DateTime.parse(inputDtInscricao);
  String formattedDate = DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(
            left: BorderSide(width: 8.0, color: getColor(etapa['etapa'])),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(etapa['nome'], style: const TextStyle(fontSize: 18)),
            Text('Local escolhido: ${etapa['local']}'),
            Text('Data da inscrição: $formattedDate'),
            Text(etapa['etapa'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
          ],
        ),
      ),
    ),
  );
}

Color getColor(String etapa) {
  if (etapa.contains('Eucaristia')) {
    return Colors.green;
  } else if (etapa.contains('Crisma')) {
    return Colors.blue;
  } else if (etapa == 'Jovens') {
    return Colors.yellow;
  } else {
    return Colors.indigo;
  }
}
