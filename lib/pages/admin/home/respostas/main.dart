import 'package:flutter/material.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/functions/create_excel.dart';
import 'package:webapp/pages/admin/home/respostas/list.dart';
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

  @override
  void initState() {
    getInscricoes().whenComplete(() => setState(() {
          isLoading = false;
          inscricoes = duplicateItems;
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
                        content: Text('Escolha uma opção para filtrar.', style: Theme.of(context).textTheme.labelLarge),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(onPressed: () => Navigator.pop(context, 'Eucaristia'), child: const Text('Eucaristia')),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(onPressed: () => Navigator.pop(context, 'Crisma'), child: const Text('Crisma')),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(onPressed: () => Navigator.pop(context, 'Jovens'), child: const Text('Jovens')),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(onPressed: () => Navigator.pop(context, 'Adultos'), child: const Text('Adultos')),
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
                        if (value != 'Limpar') {
                          inscricoes = duplicateItems.where((e) => e['etapa'].contains(value)).toList();
                        } else {
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
