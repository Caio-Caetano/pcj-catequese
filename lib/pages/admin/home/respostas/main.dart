import 'package:flutter/material.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/functions/create_excel.dart';
import 'package:webapp/pages/admin/home/respostas/list.dart';
import 'package:webapp/pages/widgets/dropdown_custom.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';

class RepostasPageView extends StatefulWidget {
  const RepostasPageView({super.key});

  @override
  State<RepostasPageView> createState() => _RepostasPageViewState();
}

class _RepostasPageViewState extends State<RepostasPageView> {
  RespostasController controllerRespostas = RespostasController(RespostasRepository());
  TextEditingController controllerSearch = TextEditingController();

  List<Map<String, dynamic>> inscricoes = [];
  List<Map<String, dynamic>> duplicateItems = [];
  bool isLoading = true;

  Future<void> getInscricoes() async {
    duplicateItems = await controllerRespostas.getAllRespostas();
  }

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
                            Text('Etapa', style: Theme.of(context).textTheme.bodyMedium),
                            DropdownButtonCustom(
                              value: etapaTotalFiltro,
                              onChanged: (String? newValue) {
                                setState(() {
                                  etapaFiltro = null;
                                  localFiltro = null;
                                  etapaTotalFiltro = newValue!;
                                });
                              },
                              items: etapaMenu,
                            ),
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
                          ],
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(onPressed: () => Navigator.pop(context, {'etapa': etapaFiltro, 'local': localFiltro, 'etapaTotal': etapaTotalFiltro}), child: const Text('Filtrar')),
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
                          if (value['etapa'] != null && value['local'] != null && value['etapaTotal'] != null) {
                            inscricoes = duplicateItems.where((e) => e['etapa'].contains(value['etapa']) && e['local'].contains(value['local'])).toList();
                          } else if (value['etapa'] != null) {
                            inscricoes = duplicateItems.where((e) => e['etapa'].contains(value['etapa'])).toList();
                          } else if (value['local'] != null) {
                            inscricoes = duplicateItems.where((e) => e['local'] == value['local']).toList();
                          } else if (value['etapaTotal'] != null) {
                            inscricoes = duplicateItems.where((e) => e['etapa'].contains(value['etapaTotal'])).toList();
                          }
                        } else {
                          etapaFiltro = null;
                          localFiltro = null;
                          etapaTotalFiltro = null;
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
            () => setState(() {
              getInscricoes();
            }),
            2,
          ),
        ],
      ),
    );
  }
}
