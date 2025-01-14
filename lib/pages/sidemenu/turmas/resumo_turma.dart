// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:webapp/controller/horarios_locais_controller.dart';
import 'package:webapp/controller/turma_controller.dart';
import 'package:webapp/controller/user_controller.dart';
import 'package:webapp/data/horarios_locais_repository.dart';
import 'package:webapp/data/turma_repository.dart';
import 'package:webapp/data/user_repository.dart';
import 'package:webapp/functions/create_excel.dart';
import 'package:webapp/model/turma_model.dart';
import 'package:webapp/pages/widgets/button_custom.dart';
import 'package:webapp/pages/widgets/dropdown_custom.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';

class ViewDetalhesTurma extends StatefulWidget {
  final List<Map<String, dynamic>> inscricoes;
  final TurmaModel turmaModel;
  final bool? appBar;
  const ViewDetalhesTurma({
    Key? key,
    required this.inscricoes,
    required this.turmaModel,
    this.appBar = true,
  }) : super(key: key);

  @override
  State<ViewDetalhesTurma> createState() => _ViewDetalhesTurmaState();
}

class _ViewDetalhesTurmaState extends State<ViewDetalhesTurma> {
  final TurmaController turmaController = TurmaController(TurmaRepository());
  final List<String> meses = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.appBar!
            ? AppBar(
                title: const Text('Detalhes da turma'),
              )
            : null,
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
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: ButtonCustom(
                              textButton: 'Editar turma',
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              icon: Icons.edit,
                              onTap: () => showDialog(context: context, builder: (context) => _ShowDialogEdit(snapshot.data!.etapa!, snapshot.data!.catequistas, snapshot.data!.local, snapshot.data!.id!)).then(
                                (value) {
                                  if (value == null || value == false) {
                                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Ação cancelada.'));
                                  } else {
                                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Editado com sucesso!'));
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: ButtonCustom(
                              textButton: 'Remover catequistas',
                              padding: const EdgeInsets.only(bottom: 10),
                              icon: Icons.remove_circle_outline,
                              onTap: () => showDialog(context: context, builder: (context) => _ShowDialogRemove(snapshot.data!.catequistas, snapshot.data!.id!)).then((value) => setState(() {})),
                            ),
                          ),
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
                                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Criando lista de presença...'));
                                  await exportListaPresenca(widget.inscricoes.map((element) => element['nome'] as String).toList(), value);
                                } else {
                                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Ação cancelada.'));
                                }
                              });
                            },
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 140, 235, 143)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (MediaQuery.of(context).size.width >= 500) Image.asset('./assets/images/excel.png', width: 30),
                                    if (MediaQuery.of(context).size.width >= 500) const SizedBox(width: 10),
                                    Text('Lista de presença', style: Theme.of(context).textTheme.labelMedium),
                                  ],
                                ),
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

class _ShowDialogEdit extends StatefulWidget {
  final String turmaId;
  final String etapaByTurma;
  final List? catequistasCadastrados;
  final String? horarioCadastrado;
  const _ShowDialogEdit(this.etapaByTurma, this.catequistasCadastrados, this.horarioCadastrado, this.turmaId);

  @override
  State<_ShowDialogEdit> createState() => __ShowDialogEditState();
}

class __ShowDialogEditState extends State<_ShowDialogEdit> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final UserController userController = UserController(UserRepository());
  final HorariosLocaisController horariosLocaisController = HorariosLocaisController(HorariosLocaisRepository());
  final TurmaController turmaController = TurmaController(TurmaRepository());

  String? catequista;
  String? local;

  List<Map<String, dynamic>> users = [];
  List locais = [];

  List<String?> catequistas = [null];
  List<bool> catequistasAdicionado = [false];

  getData(String etapa) async {
    users = await userController.getUsuarios(etapa: etapa, withCoord: true);
    for (var element in widget.catequistasCadastrados!) {
      users.removeWhere((value) => element == value['nome']);
    }
    locais = await horariosLocaisController.getHorariosLocais(etapa.toLowerCase());
    locais.remove(widget.horarioCadastrado);
    setState(() {});
  }

  @override
  void initState() {
    String etapa = widget.etapaByTurma;
    if (widget.etapaByTurma.contains('-')) {
      etapa = widget.etapaByTurma.split('-')[1].trim();
    }
    getData(etapa);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar turma', style: Theme.of(context).textTheme.titleMedium),
      content: Form(
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (users.isEmpty)
              Text('Não há catequistas para adicionar', style: Theme.of(context).textTheme.titleMedium)
            else
              DropdownButtonCustom(
                label: 'Catequista',
                onChanged: (value) {
                  setState(() {
                    catequistas[0] = value;
                    if (!catequistasAdicionado[0]) {
                      catequistasAdicionado[0] = true;
                    }
                  });
                },
                value: catequistas[0],
                items: users
                    .map((e) => DropdownMenuItem<String>(
                        value: '${e['nome']}',
                        child: Text(
                          '${e['nome']} | ${e['etapa'] ?? 'Não definido'} - ${e['etapaCoord']} | Coordenador: ${e['level'] == 1 ? 'Sim' : 'Não'}',
                          style: Theme.of(context).textTheme.labelMedium,
                        )))
                    .toList(),
              ),
            if (catequistas.isNotEmpty)
              for (var i = 1; i < catequistas.length; i++)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DropdownButtonCustom(
                        label: 'Catequista',
                        onChanged: (value) {
                          setState(() {
                            if (catequistasAdicionado[i] != true) {
                              catequistas[i] = value;
                              catequistasAdicionado[i] = true;
                            }
                          });
                        },
                        validator: (value) {
                          if (catequistas.where((element) => element != catequistas[i]).contains(value)) {
                            return 'Possíveis catequistas repetidos.';
                          } else {
                            return null;
                          }
                        },
                        value: catequistas[i],
                        items: users
                            .map((e) => DropdownMenuItem<String>(
                                value: '${e['nome']}',
                                child: Text(
                                  '${e['nome']} | ${e['etapa'] ?? 'Não definido'} - ${e['etapaCoord']} | Coordenador: ${e['level'] == 1 ? 'Sim' : 'Não'}',
                                  style: Theme.of(context).textTheme.labelMedium,
                                )))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: IconButton.outlined(
                        onPressed: () {
                          setState(() {
                            catequistas.removeAt(i);
                            catequistasAdicionado.removeAt(i);
                          });
                        },
                        icon: const Icon(Icons.close, color: Color.fromARGB(255, 255, 0, 0)),
                      ),
                    )
                  ],
                ),
            if (users.isNotEmpty)
              ButtonCustom(
                icon: Icons.add,
                textButton: 'Adicionar catequista',
                onTap: () => setState(() {
                  catequistasAdicionado.add(false);
                  catequistas.add(null);
                }),
              ),
            DropdownButtonCustom(
              label: 'Horarios',
              onChanged: (value) {
                setState(() {
                  local = value;
                });
              },
              value: local,
              items: locais
                  .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(
                        e,
                        style: Theme.of(context).textTheme.labelMedium,
                      )))
                  .toList(),
            ),
          ],
        ),
      ),
      actions: [
        ButtonCustom(textButton: 'Cancelar', onTap: () => Navigator.pop(context, false)),
        ButtonCustom(
          textButton: 'Editar',
          onTap: () async {
            if (key.currentState!.validate()) {
              await turmaController.updateTurma(widget.turmaId, local: local, catequistas: catequistas).then((value) {
                if (context.mounted) Navigator.pop(context, true);
              });
            }
          },
          color: const Color.fromARGB(255, 108, 212, 111),
        ),
      ],
    );
  }
}

class _ShowDialogRemove extends StatefulWidget {
  final String turmaId;
  final List? catequistasCadastrados;
  const _ShowDialogRemove(this.catequistasCadastrados, this.turmaId);

  @override
  State<_ShowDialogRemove> createState() => __ShowDialogRemoveState();
}

class __ShowDialogRemoveState extends State<_ShowDialogRemove> {
  final TurmaController turmaController = TurmaController(TurmaRepository());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remover catequistas', style: Theme.of(context).textTheme.titleMedium),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (var catequista in widget.catequistasCadastrados!)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Remover catequista: $catequista'),
                        content: const Text('Você está prestes a deletar o catequista desta turma, tem certeza disso?'),
                        actions: [
                          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Deletar')),
                          ElevatedButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                        ],
                      ),
                    ).then((value) async {
                      if (value == null || !value) {
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Ação cancelada.'));
                      } else {
                        await turmaController.removeCatequistaCadastrado(widget.turmaId, catequista).then(
                          (value) {
                            setState(() {});
                            if (context.mounted) {
                              return ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Deletado com sucesso.'));
                            }
                          },
                        );
                      }
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                      child: Row(
                        children: [
                          Text(catequista, style: Theme.of(context).textTheme.titleSmall),
                          const Spacer(),
                          Icon(Icons.close, color: Colors.redAccent.withOpacity(0.4)),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
