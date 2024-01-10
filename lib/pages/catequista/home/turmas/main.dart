import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/controller/turma_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/data/turma_repository.dart';
import 'package:webapp/functions/create_excel.dart';
import 'package:webapp/model/turma_model.dart';
import 'package:webapp/pages/widgets/button_custom.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';

class TurmasCatequista extends StatelessWidget {
  final String? nomeCatequista;
  const TurmasCatequista({super.key, this.nomeCatequista});

  @override
  Widget build(BuildContext context) {
    final TurmaController turmaController = TurmaController(TurmaRepository());
    final RespostasController respostasController = RespostasController(RespostasRepository());

    return Scaffold(
      body: FutureBuilder(
          future: turmaController.getTurmaByCatequista(catequista: nomeCatequista!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Carregando...'));
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text('Sem turmas criadas'));
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => FutureBuilder(
                    future: respostasController.getInscricoesByTurma(snapshot.data![index]),
                    builder: (context, snp) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => _DetalhesTurma(inscricoes: snp.data!, turmaModel: snapshot.data![index]))),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: (snp.connectionState == ConnectionState.waiting)
                                ? const Text('Carregando informações da turma...')
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(child: Text('${snapshot.data![index].etapa} | ${snapshot.data![index].local!.split('no').last.trim()}')),
                                      Text('Catequista: ${snapshot.data![index].catequistas![0] ?? ''}', style: Theme.of(context).textTheme.labelSmall),
                                      Text('Local: ${snapshot.data![index].local ?? ''}', style: Theme.of(context).textTheme.labelSmall),
                                      Text('Tamanho da turma: ${snp.data!.length}', style: Theme.of(context).textTheme.labelSmall),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return const Center(child: Text('Lista vazia.'));
            }
          }),
    );
  }
}

class _DetalhesTurma extends StatefulWidget {
  final List<Map<String, dynamic>> inscricoes;
  final TurmaModel turmaModel;
  const _DetalhesTurma({
    Key? key,
    required this.inscricoes,
    required this.turmaModel,
  }) : super(key: key);

  @override
  State<_DetalhesTurma> createState() => __DetalhesTurmaState();
}

class __DetalhesTurmaState extends State<_DetalhesTurma> {
  final TurmaController turmaController = TurmaController(TurmaRepository());
  final List<String> meses = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Detalhes da turma')),
        body: FutureBuilder(
          future: turmaController.getTurma(widget.turmaModel.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [CircularProgressIndicator(), Text('Carregando...')],
                ),
              );
            } else {
              return Row(
                children: [
                  Expanded(
                      child: DataTable2(
                          minWidth: 500,
                          isHorizontalScrollBarVisible: true,
                          columns: const [
                            DataColumn(label: Text('Nome')),
                            DataColumn(label: Text('Telefone')),
                            DataColumn(label: Text('E-mail')),
                          ],
                          rows: widget.inscricoes
                              .map((e) => DataRow(cells: [
                                    DataCell(Text(e['nome'])),
                                    DataCell(Text(e['telefone'])),
                                    DataCell(Text(e['email'])),
                                  ]))
                              .toList())),
                  Container(
                    decoration: const BoxDecoration(border: Border(left: BorderSide(color: Colors.red))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Catequistas: ', style: Theme.of(context).textTheme.titleMedium),
                          for (var catequista in snapshot.data!.catequistas!) Text(catequista, style: Theme.of(context).textTheme.labelMedium),
                          Padding(padding: const EdgeInsets.only(top: 12.0), child: Container(height: 3, width: 50, color: Colors.red)),
                          Text('Horário: ', style: Theme.of(context).textTheme.titleMedium),
                          Text(snapshot.data!.local!.split('no')[0].trim(), style: Theme.of(context).textTheme.labelMedium),
                          Text('Local: ', style: Theme.of(context).textTheme.titleMedium),
                          Text(snapshot.data!.local!.split('no')[1].trim(), style: Theme.of(context).textTheme.labelMedium),
                          Padding(padding: const EdgeInsets.only(top: 12.0), child: Container(height: 3, width: 50, color: Colors.red)),
                          Text('Ações: ', style: Theme.of(context).textTheme.titleMedium),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      title: const Text('Selecione o mês'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: meses
                                                .map((mes) => SizedBox(
                                                      width: 200,
                                                      child: ButtonCustom(
                                                        textButton: mes,
                                                        onTap: () {
                                                          Navigator.pop(context, mes);
                                                        },
                                                      ),
                                                    ))
                                                .toList(),
                                        ),
                                      ))).then((value) async {
                                if (value != null && meses.contains(value)) {
                                  ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Criando lista de presença...'));
                                  await exportListaPresenca(widget.inscricoes.map((element) => element['nome'] as String).toList(), value);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Ação cancelada.'));
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 140, 235, 143)),
                              child: Row(
                                children: [
                                  if (MediaQuery.of(context).size.width >= 500) Image.asset('./assets/images/excel.png', width: 30),
                                  if (MediaQuery.of(context).size.width >= 500) const SizedBox(width: 10),
                                  Text('Lista de presença', style: Theme.of(context).textTheme.labelMedium),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ));
  }
}
