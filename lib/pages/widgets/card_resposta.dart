import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webapp/pages/widgets/dialog_delete.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';

Widget cardResposta({required Map etapa, required BuildContext context, required VoidCallback setstate, required int accessLevel}) {
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
            if (accessLevel == 2) Row(
              children: [
                const Spacer(),
                // IconButton(
                //   onPressed: () {
                //     showDialog(
                //         context: context,
                //         builder: (context) {
                //           return editDialog(() {
                //             Navigator.pop(context);
                //             setstate();
                //           });
                //         }).then((value) => ScaffoldMessenger.of(context).showSnackBar(createSnackBar('✅ Editado com sucesso!')));
                //   },
                //   icon: const Icon(Icons.edit, color: Colors.grey),
                // ),
                // const SizedBox(width: 5),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return deleteDialog(etapa['id'], () {
                            Navigator.pop(context);
                            setstate();
                          });
                        }).then((value) => ScaffoldMessenger.of(context).showSnackBar(createSnackBar('❌ Deletado com sucesso!')));
                  },
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                ),
              ],
            )
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
