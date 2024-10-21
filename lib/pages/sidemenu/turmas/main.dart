import 'package:flutter/material.dart';
import 'package:webapp/controller/horarios_locais_controller.dart';
import 'package:webapp/controller/turma_controller.dart';
import 'package:webapp/controller/user_controller.dart';
import 'package:webapp/data/horarios_locais_repository.dart';
import 'package:webapp/data/turma_repository.dart';
import 'package:webapp/data/user_repository.dart';
import 'package:webapp/model/turma_model.dart';
import 'package:webapp/pages/sidemenu/turmas/card_turma.dart';
import 'package:webapp/pages/widgets/button_custom.dart';
import 'package:webapp/pages/widgets/dropdown_custom.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';

class TurmasPageView extends StatefulWidget {
  final String? etapa;
  const TurmasPageView({super.key, this.etapa});

  @override
  State<TurmasPageView> createState() => _TurmasPageViewState();
}

class _TurmasPageViewState extends State<TurmasPageView> {
  @override
  Widget build(BuildContext context) {
    TurmaController turmaController = TurmaController(TurmaRepository());
    final ValueNotifier<TurmaModel?> valueNotifier = ValueNotifier<TurmaModel?>(null);
    return Scaffold(
      body: FutureBuilder(
          future: turmaController.getAllTurmas(etapa: widget.etapa),
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
                itemBuilder: (context, index) => CardTurma(model: snapshot.data![index], onDelete: () => setState(() {})),
              );
            } else {
              return const Center(child: Text('Lista vazia.'));
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _CriarMenuTurma(
              valueNotifier: valueNotifier,
              onSubmit: () => Navigator.pop(context, true),
              onClose: () => Navigator.pop(context, false),
              etapa: widget.etapa,
            ),
          ).then(
            (value) async {
              if (value == null || !value) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Ação cancelada.'));
              } else {
                if (valueNotifier.value == null) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Informações inválidas.'));
                } else {
                  await turmaController.addTurma(valueNotifier.value!).then((value) => setState(() {}));
                }
              }
            },
          );
        },
        label: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Adicionar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}

class _CriarMenuTurma extends StatefulWidget {
  final VoidCallback onSubmit;
  final VoidCallback onClose;
  final ValueNotifier<TurmaModel?> valueNotifier;
  final String? etapa;
  const _CriarMenuTurma({required this.onSubmit, required this.onClose, required this.valueNotifier, this.etapa});

  @override
  State<_CriarMenuTurma> createState() => __CriarMenuTurmaState();
}

class __CriarMenuTurmaState extends State<_CriarMenuTurma> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final UserController userController = UserController(UserRepository());
  final HorariosLocaisController horariosLocaisController = HorariosLocaisController(HorariosLocaisRepository());

  String? etapa;
  String? local;

  List<String?> catequistas = [null];
  List<bool> catequistasAdicionado = [false];

  List<Map<String, dynamic>> users = [];
  List locais = [];

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> etapaMenu = [
      DropdownMenuItem(value: '1º Etapa - Eucaristia', child: Text('1º Etapa - Eucaristia', style: Theme.of(context).textTheme.labelMedium)),
      DropdownMenuItem(value: '2º Etapa - Eucaristia', child: Text('2º Etapa - Eucaristia', style: Theme.of(context).textTheme.labelMedium)),
      DropdownMenuItem(value: '3º Etapa - Eucaristia', child: Text('3º Etapa - Eucaristia', style: Theme.of(context).textTheme.labelMedium)),
      DropdownMenuItem(value: '1º Etapa - Crisma', child: Text('1º Etapa - Crisma', style: Theme.of(context).textTheme.labelMedium)),
      DropdownMenuItem(value: '2º Etapa - Crisma', child: Text('2º Etapa - Crisma', style: Theme.of(context).textTheme.labelMedium)),
      DropdownMenuItem(value: '3º Etapa - Crisma', child: Text('3º Etapa - Crisma', style: Theme.of(context).textTheme.labelMedium)),
      DropdownMenuItem(value: 'Jovens', child: Text('Jovens', style: Theme.of(context).textTheme.labelMedium)),
      DropdownMenuItem(value: 'Adultos', child: Text('Adultos', style: Theme.of(context).textTheme.labelMedium)),
    ];

    return AlertDialog(
      title: const Text('Criar turma'),
      content: Form(
        key: key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonCustom(
                label: 'Etapa',
                onChanged: (value) async {
                  await userController.getUsuarios(etapa: value?.split('-')[1].trim(), withCoord: true).then((v) => setState(() {
                        users = v;
                        etapa = value;
                      }));
                  await horariosLocaisController.getHorariosLocais(value!.split('-')[1].trim().toLowerCase()).then((value) => setState(() {
                        locais = value;
                      }));
                },
                value: etapa,
                items: widget.etapa != null
                    ? widget.etapa == 'Jovens' || widget.etapa == 'Adultos'
                        ? [
                            DropdownMenuItem(value: widget.etapa, child: Text(widget.etapa ?? '', style: const TextStyle(fontSize: 14))),
                          ]
                        : [
                            DropdownMenuItem(value: '1º Etapa - ${widget.etapa}', child: Text('1º Etapa - ${widget.etapa}', style: const TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: '2º Etapa - ${widget.etapa}', child: Text('2º Etapa - ${widget.etapa}', style: const TextStyle(fontSize: 14))),
                            DropdownMenuItem(value: '3º Etapa - ${widget.etapa}', child: Text('3º Etapa - ${widget.etapa}', style: const TextStyle(fontSize: 14))),
                          ]
                    : etapaMenu,
              ),
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
              ButtonCustom(
                icon: Icons.add,
                textButton: 'Adicionar catequista',
                onTap: () => setState(() {
                  catequistasAdicionado.add(false);
                  catequistas.add(null);
                }),
              ),
              DropdownButtonCustom(
                label: 'Horários',
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
      ),
      actions: [
        ElevatedButton(onPressed: widget.onClose, child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () {
            if (key.currentState!.validate()) {
              if ((catequistas[0] == null || etapa == null || local == null)) {
                widget.valueNotifier.value = null;
              } else {
                catequistas.removeWhere((element) => element == null);
                widget.valueNotifier.value = TurmaModel(catequistas: catequistas, etapa: etapa, local: local);
              }
              widget.onSubmit();
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
