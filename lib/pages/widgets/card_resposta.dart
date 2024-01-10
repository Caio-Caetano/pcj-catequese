import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/controller/turma_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/data/turma_repository.dart';
import 'package:webapp/model/turma_model.dart';
import 'package:webapp/pages/widgets/dialog_archive_inscricao.dart';
import 'package:webapp/pages/widgets/dialog_delete.dart';
import 'package:webapp/pages/widgets/dialog_view.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';

Widget cardResposta({required Map<String, dynamic> inscricao, required BuildContext context, required VoidCallback setstate, required int accessLevel}) {
  final String inputDtInscricao = inscricao['dataInscricao'];
  final DateTime dateTime = DateTime.parse(inputDtInscricao);
  final String formattedDate = DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);
  final TurmaController turmaController = TurmaController(TurmaRepository());
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
            Text('Local escolhido: ${inscricao['local'] ?? 'A definir'}'),
            Text('Data da inscrição: $formattedDate'),
            Text('Contato: ${inscricao['telefone'].substring(0, 2)} ${inscricao['telefone'].substring(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
            Text(inscricao['etapa'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
            Text('Catequistas atribuídos: ${inscricao['turma'] == null ? 'Não atribuído' : inscricao['turma']['catequistas']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
            Row(
              children: [
                const Spacer(),
                FutureBuilder(
                    future: turmaController.getTurmas(etapa: inscricao['etapa']),
                    builder: (context, snapshot) {
                      return PopupMenuButton(
                          enabled: !(snapshot.connectionState == ConnectionState.waiting),
                          tooltip: snapshot.connectionState == ConnectionState.waiting ? 'Carregando' : 'Atribuir turma',
                          onSelected: (value) => handleClick(value, inscricao['id'], setstate),
                          itemBuilder: (context) {
                            return snapshot.connectionState == ConnectionState.waiting
                                ? [PopupMenuItem<TurmaModel>(value: TurmaModel(), child: Text('Nulo', style: Theme.of(context).textTheme.labelSmall))]
                                : snapshot.data!.where((e) => e.catequistas!.isNotEmpty).map((e) => PopupMenuItem<TurmaModel>(value: e, child: Text('${e.catequistas![0]} | ${e.local}', style: Theme.of(context).textTheme.labelSmall))).toList();
                          });
                    }),
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
                              onSubmit: (reason) async {
                                await controller.archiveInscricao(inscricao['id'], reason, inscricao['archived'] == null ? false : inscricao['archived']['isNowArchived']).then((value) {
                                  Navigator.pop(context, value);
                                  setstate();
                                });
                              },
                            );
                          }).then((value) => value == null || !value ? ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Ação cancelada.')) : ScaffoldMessenger.of(context).showSnackBar(createSnackBar('📁 Arquivado com sucesso.')));
                    },
                    icon: const Icon(Icons.archive, color: Colors.blueGrey),
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

void handleClick(TurmaModel turma, String id, VoidCallback setState) async {
  RespostasController respostasController = RespostasController(RespostasRepository());
  var result = await respostasController.updateInscricaoTurma(id, turma);
  if (result) {
    setState();
  }
}
