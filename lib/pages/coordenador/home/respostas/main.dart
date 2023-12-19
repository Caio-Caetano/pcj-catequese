import 'package:flutter/material.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/functions/create_excel.dart';
import 'package:webapp/pages/admin/home/respostas/list.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';

class RepostasPageViewCoord extends StatefulWidget {
  const RepostasPageViewCoord({super.key, required this.etapa});
  final String? etapa;

  @override
  State<RepostasPageViewCoord> createState() => _RepostasPageViewCoordState();
}

class _RepostasPageViewCoordState extends State<RepostasPageViewCoord> {
  RespostasController controllerRespostas = RespostasController(RespostasRepository());
  TextEditingController controllerSearch = TextEditingController();

  List<Map<String, dynamic>> inscricoes = [];
  List<Map<String, dynamic>> duplicateItems = [];
  bool isLoading = true;

  Future<void> getInscricoes() async {
    duplicateItems = await controllerRespostas.getRespostas(etapa: widget.etapa);
  }

  String? localFiltro;

  List<String> locaisUnicos = [];

  @override
  void initState() {
    getInscricoes().whenComplete(() => setState(() {
          isLoading = false;
          inscricoes = duplicateItems;
          for (var inscricao in inscricoes) {
            if (!locaisUnicos.contains(inscricao['local'])) {
              locaisUnicos.add(inscricao['local']);
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

  String? etapaFiltro;

  List<DropdownMenuItem<String>> etapaMenuFiltro = const [
    DropdownMenuItem(value: '1º Etapa', child: Text('1º Etapa', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: '2º Etapa', child: Text('2º Etapa', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: '3º Etapa', child: Text('3º Etapa', style: TextStyle(fontSize: 14))),
  ];

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
                            DropdownButtonFormField(
                                decoration: InputDecoration(
                                  hintText: 'Selecione...',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(20),
                                dropdownColor: Colors.grey[400],
                                value: etapaFiltro,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    etapaFiltro = newValue!;
                                  });
                                },
                                items: etapaMenuFiltro),
                            Text('Local', style: Theme.of(context).textTheme.bodyMedium),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                hintText: 'Selecione...',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(20),
                              dropdownColor: Colors.grey[400],
                              value: localFiltro,
                              onChanged: (String? newValue) {
                                setState(() {
                                  localFiltro = newValue!;
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
                            child: ElevatedButton(onPressed: () => Navigator.pop(context, {'etapa': etapaFiltro, 'local': localFiltro}), child: const Text('Filtrar')),
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
                          if (value['etapa'] != null && value['local'] != null) {
                            inscricoes = duplicateItems.where((e) => e['etapa'].contains(value['etapa']) && e['local'].contains(value['local'])).toList();
                          } else if (value['etapa'] != null) {
                            inscricoes = duplicateItems.where((e) => e['etapa'].contains(value['etapa'])).toList();
                          } else if (value['local'] != null) {
                            inscricoes = duplicateItems.where((e) => e['local'].contains(value['local'])).toList();
                          }
                        } else {
                          etapaFiltro = null;
                          localFiltro = null;
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
            1,
          ),
        ],
      ),
    );
  }
}
