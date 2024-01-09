import 'package:flutter/material.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/functions/create_excel.dart';
import 'package:webapp/pages/sidemenu/respostas/list.dart';
import 'package:webapp/pages/widgets/dropdown_custom.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';

class RepostasPageView extends StatefulWidget {
  final String? etapa;
  final int accessLevel;
  const RepostasPageView({super.key, this.etapa, required this.accessLevel});

  @override
  State<RepostasPageView> createState() => _RepostasPageViewState();
}

class _RepostasPageViewState extends State<RepostasPageView> {
  RespostasController controllerRespostas = RespostasController(RespostasRepository());
  TextEditingController controllerSearch = TextEditingController();

  List<Map<String, dynamic>> inscricoes = [];
  List<Map<String, dynamic>> duplicateItems = [];
  bool isLoading = true;

  String? localFiltro;
  List<String> locaisUnicos = [];

  String? etapaFiltro;
  List<String> etapasUnicas = [];

  String? etapaTotalFiltro;
  List<DropdownMenuItem<String>> etapaMenu = const [
    DropdownMenuItem(value: 'Eucaristia', child: Text('Eucarista', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Crisma', child: Text('Crisma', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Jovens', child: Text('Jovens', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Adultos', child: Text('Adultos', style: TextStyle(fontSize: 14))),
  ];

  String? turmaAtribuida;
  List<DropdownMenuItem<String>> turmaMenu = const [
    DropdownMenuItem(value: 'Todos', child: Text('Todos', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Sim', child: Text('Sim', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Não', child: Text('Não', style: TextStyle(fontSize: 14))),
  ];

  Future<List<Map<String, dynamic>>> getInscricoes() async {
    duplicateItems = await controllerRespostas.getRespostas(etapa: widget.etapa);

    inscricoes = duplicateItems.where((e) {
      // Verifica se está selecionado a ETAPA (Eucaristia, Crisma, Jovens ou Adultos)
      if (etapaTotalFiltro != null) {
        return e['etapa'].contains(etapaTotalFiltro);
      }

      // Verifica se está selecionado a ETAPA ESPECÍFICA
      if (etapaFiltro != null) {
        // Verifica se possui LOCAL também selecionado
        if (localFiltro != null) {
          return e['etapa'].contains(etapaFiltro) && e['local'].contains(localFiltro);
        }
        return e['etapa'].contains(etapaFiltro);
      }

      // Verifica se apenas o LOCAL está selecionado
      if (localFiltro != null) {
        return e['local'] == localFiltro;
      }

      return false;
    }).toList();

    if (inscricoes.isEmpty) inscricoes = duplicateItems;

    return inscricoes;
  }

  @override
  void initState() {
    getInscricoes().whenComplete(() => setState(() {
          isLoading = false;
          inscricoes = duplicateItems;
          for (var inscricao in duplicateItems) {
            if (inscricao['local'] != null) {
              if (!locaisUnicos.contains(inscricao['local'])) {
                locaisUnicos.add(inscricao['local']);
              }
            }
            if (!etapasUnicas.contains(inscricao['etapa'])) {
              etapasUnicas.add(inscricao['etapa']);
            }
          }
        }));
    super.initState();
  }

  void filterSearchResults(String query) {
    setState(() {
      inscricoes = duplicateItems.where((item) => item['nome'].toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    inscricoes.sort((a, b) => b['dataInscricao'].compareTo(a['dataInscricao']));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFieldCustom(
                  iconPrefix: const Icon(Icons.search),
                  controller: controllerSearch,
                  hintText: 'Pesquisar por nome...',
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Filtro'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.etapa == null) Text('Etapa', style: Theme.of(context).textTheme.bodyMedium),
                            if (widget.etapa == null)
                              DropdownButtonCustom(
                                value: etapaTotalFiltro,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    etapaFiltro = null;
                                    localFiltro = null;
                                    turmaAtribuida = null;
                                    etapaTotalFiltro = newValue!;
                                  });
                                },
                                items: etapaMenu,
                              ),
                            Padding(padding: const EdgeInsets.only(top: 12.0), child: Container(height: 3, width: 50, color: Colors.red)),
                            Text('Etapa detalhada', style: Theme.of(context).textTheme.bodyMedium),
                            DropdownButtonCustom(
                              value: etapaFiltro,
                              onChanged: (String? newValue) {
                                setState(() {
                                  etapaFiltro = newValue!;
                                  etapaTotalFiltro = null;
                                });
                              },
                              items: etapasUnicas.map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                            ),
                            Text('Local', style: Theme.of(context).textTheme.bodyMedium),
                            DropdownButtonCustom(
                              value: localFiltro,
                              onChanged: (String? newValue) {
                                setState(() {
                                  localFiltro = newValue!;
                                  etapaTotalFiltro = null;
                                });
                              },
                              items: locaisUnicos.map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 12.0), child: Container(height: 3, width: 50, color: Colors.red)),
                            DropdownButtonCustom(
                              label: 'Turma atribuída',
                              value: turmaAtribuida,
                              onChanged: (String? newValue) {
                                setState(() {
                                  turmaAtribuida = newValue;
                                });
                              },
                              items: turmaMenu,
                            ),
                          ],
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(onPressed: () => Navigator.pop(context, {'etapa': etapaFiltro, 'local': localFiltro, 'etapaTotal': etapaTotalFiltro, 'turma': turmaAtribuida}), child: const Text('Filtrar')),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(onPressed: () => Navigator.pop(context, 'Limpar'), child: const Text('Limpar')),
                          ),
                        ],
                      );
                    },
                  ).then(
                    (value) => setState(
                      () {
                        value ??= 'Limpar';
                        if (value != 'Limpar') {
                          inscricoes = duplicateItems.where((e) {
                            // Verifica se está selecionado a ETAPA (Eucaristia, Crisma, Jovens ou Adultos)
                            if (value['etapaTotal'] != null) {
                              return e['etapa'].contains(value['etapaTotal']);
                            }

                            // Verifica se está selecionado a ETAPA ESPECÍFICA
                            if (value['etapa'] != null) {
                              // Verifica se possui LOCAL também selecionado
                              if (value['local'] != null) {
                                return e['etapa'].contains(value['etapa']) && e['local'].contains(value['local']);
                              }
                              return e['etapa'].contains(value['etapa']);
                            }

                            // Verifica se apenas o LOCAL está selecionado
                            if (value['local'] != null) {
                              return e['local'] == value['local'];
                            }

                            // Retorna false como ERRO
                            return false;
                          }).toList();

                          // Última verificação para saber se está com TURMA ou NÃO
                          if (value['turma'] != null) {
                            if (inscricoes.isNotEmpty) {
                              if (value['turma'] == 'Sim') {
                                inscricoes = inscricoes.where((e) => e['turma'] != null && e['turma']['catequistas'].isNotEmpty).toList();
                              } else if (value['turma'] == 'Não') {
                                inscricoes = inscricoes.where((e) => e['turma'] == null || e['turma']['catequistas'].isEmpty).toList();
                              } else {
                                inscricoes = inscricoes;
                              }
                            } else {
                              if (value['turma'] == 'Sim') {
                                inscricoes = duplicateItems.where((e) => e['turma'] != null && e['turma']['catequistas'].isNotEmpty).toList();
                              } else if (value['turma'] == 'Não') {
                                inscricoes = duplicateItems.where((e) => e['turma'] == null || e['turma']['catequistas'].isEmpty).toList();
                              } else {
                                inscricoes = duplicateItems;
                              }
                            }
                          }
                        } else {
                          etapaFiltro = null;
                          localFiltro = null;
                          etapaTotalFiltro = null;
                          turmaAtribuida = null;
                          inscricoes = duplicateItems;
                        }
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color.fromARGB(100, 74, 74, 74)),
                  child: Image.asset('./assets/images/filter.png', width: 30),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () async => await exportToExcel(inscricoes),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color.fromARGB(255, 140, 235, 143)),
                  child: Image.asset('./assets/images/excel.png', width: 30),
                ),
              ),
            ],
          ),
          if (isLoading) const Text('Carregando...'),
          criarListaInscricoes(
            inscricoes,
            () async => await getInscricoes().then(
              (value) => setState(
                () {
                  inscricoes = value;
                },
              ),
            ),
            widget.accessLevel,
          ),
        ],
      ),
    );
  }
}
