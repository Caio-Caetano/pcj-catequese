import 'package:flutter/material.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/pages/widgets/dialog_archive_inscricao.dart';
import 'package:webapp/pages/widgets/dialog_delete.dart';
import 'package:webapp/pages/widgets/dialog_view.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';

Widget cardArchived({required Map<String, dynamic> inscricao, required BuildContext context, required VoidCallback setstate, required int accessLevel}) {
  final RespostasController controller = RespostasController(RespostasRepository());

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(
            left: BorderSide(width: 8.0, color: getColor(inscricao['etapa'])),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(inscricao['nome'], style: const TextStyle(fontSize: 18)),
            const Text('Motivo que está arquivado:', style: TextStyle(fontSize: 18)),
            for (var reason in inscricao['archived']['reasons']) Text(reason, style: Theme.of(context).textTheme.labelMedium),
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return viewDialog(
                          inscricao,
                          () {
                            Navigator.pop(context);
                            setstate();
                          },
                          context,
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.visibility, color: Colors.green),
                ),
                if (accessLevel == 2)
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DialogArchiveInscricao(
                              nome: inscricao['nome'],
                              archiving: false,
                              onSubmit: (reason) async {
                                await controller.archiveInscricao(inscricao['id'], reason, inscricao['archived'] == null ? false : inscricao['archived']['isNowArchived']).then((value) {
                                  Navigator.pop(context, value);
                                  setstate();
                                });
                              },
                            );
                          }).then((value) => value == null || !value ? ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Ação cancelada.')) : ScaffoldMessenger.of(context).showSnackBar(createSnackBar('📁 Restaurado com sucesso.')));
                    },
                    icon: const Icon(Icons.unarchive, color: Colors.blueGrey),
                  ),
                if (accessLevel == 2)
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return deleteDialog(
                                id: inscricao['id'],
                                submit: () {
                                  Navigator.pop(context, true);
                                  setstate();
                                },
                                back: () => Navigator.pop(context, false));
                          }).then((value) => value == null || !value ? ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Ação cancelada.')) : ScaffoldMessenger.of(context).showSnackBar(createSnackBar('❌ Deletado com sucesso!')));
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                  ),
              ],
            ),
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
