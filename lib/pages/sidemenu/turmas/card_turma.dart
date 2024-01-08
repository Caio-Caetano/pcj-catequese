import 'package:flutter/material.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/controller/turma_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/data/turma_repository.dart';
import 'package:webapp/model/turma_model.dart';
import 'package:webapp/pages/sidemenu/turmas/resumo_turma.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';

class CardTurma extends StatefulWidget {
  final TurmaModel model;
  final VoidCallback onDelete;
  const CardTurma({super.key, required this.model, required this.onDelete});

  @override
  State<CardTurma> createState() => _CardTurmaState();
}

class _CardTurmaState extends State<CardTurma> {
  @override
  Widget build(BuildContext context) {
    final RespostasController respostasController = RespostasController(RespostasRepository());
    final TurmaController turmaController = TurmaController(TurmaRepository());
    return FutureBuilder(
        future: respostasController.getInscricoesByTurma(widget.model),
        builder: (context, snapshot) {
          return InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewDetalhesTurma(inscricoes: snapshot.data!, turmaModel: widget.model))),
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) => _DeleteDialog(
                        confirm: () => Navigator.pop(context, true),
                        cancel: () => Navigator.pop(context, false),
                      )).then((value) async {
                if (value == null || !value) {
                  ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Ação cancelada.'));
                } else {
                  await turmaController.deleteTurma(widget.model.id!).then((value) {
                    widget.onDelete();
                    return ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Deletado com sucesso.'));
                  });
                }
              });
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: (snapshot.connectionState == ConnectionState.waiting)
                    ? const Text('Carregando informações da turma...')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Text('${widget.model.etapa} | ${widget.model.local!.split('no').last.trim()}')),
                          Text('Catequista: ${widget.model.catequistas![0] ?? ''}', style: Theme.of(context).textTheme.labelSmall),
                          Text('Local: ${widget.model.local ?? ''}', style: Theme.of(context).textTheme.labelSmall),
                          Text('Tamanho da turma: ${snapshot.data!.length}', style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
              ),
            ),
          );
        });
  }
}

class _DeleteDialog extends StatelessWidget {
  final VoidCallback confirm;
  final VoidCallback cancel;
  const _DeleteDialog({required this.confirm, required this.cancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deletar turma'),
      content: const Text('Você está prestes a deletar uma turma, tem certeza disso?'),
      actions: [
        ElevatedButton(onPressed: () => confirm(), child: const Text('Deletar')),
        ElevatedButton(onPressed: () => cancel(), child: const Text('Cancelar')),
      ],
    );
  }
}
