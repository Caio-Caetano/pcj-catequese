import 'package:flutter/material.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/functions/create_excel.dart';
// import 'package:webapp/pages/admin/insert_page/individual_page.dart';
// import 'package:webapp/pages/sidemenu/respostas/admin/insert_manually_dialog.dart';
import 'package:webapp/pages/sidemenu/respostas/list.dart';
import 'package:webapp/pages/widgets/select_ano.dart';
import 'package:webapp/pages/widgets/badge_filtro.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';

class RepostasPageView extends StatefulWidget {
  final String? etapa;
  final int accessLevel;
  const RepostasPageView({super.key, this.etapa, required this.accessLevel});

  @override
  State<RepostasPageView> createState() => _RepostasPageViewState();
}

class _RepostasPageViewState extends State<RepostasPageView> {
  RespostasController controllerRespostas =
      RespostasController(RespostasRepository());
  TextEditingController controllerSearch = TextEditingController();

  List<Map<String, dynamic>> inscricoes = [];
  List<Map<String, dynamic>> duplicateItems = [];
  bool isLoading = true;

  String? localFiltro;
  List<String> locaisUnicos = [];

  String? etapaFiltro;
  List<String> etapasUnicas = [];

  String? etapaTotalFiltro;
  List<String> etapaMenu = [
    'Todos',
    'Eucaristia',
    'Crisma',
    'Jovens',
    'Adultos'
  ];

  String? turmaAtribuida;
  List<String> turmaMenu = ['Todos', 'Sim', 'Não'];

  List<Widget> filtroBadges = [];

  Future<List<Map<String, dynamic>>> getInscricoes(
      {String? queryPesquisando, String? collection}) async {
    duplicateItems = await controllerRespostas.getRespostas(
        etapa: widget.etapa, collection: collection);

    inscricoes = duplicateItems.where((e) {
      // Verifica se está selecionado a ETAPA (Eucaristia, Crisma, Jovens ou Adultos)
      if (etapaTotalFiltro != null) {
        return e['etapa'].contains(etapaTotalFiltro);
      }

      // Verifica se está selecionado a ETAPA ESPECÍFICA
      if (etapaFiltro != null) {
        // Verifica se possui LOCAL também selecionado
        if (localFiltro != null) {
          return e['etapa'].contains(etapaFiltro) &&
              e['local'].contains(localFiltro);
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
    super.initState();
    getInscricoes().whenComplete(() => setState(() {
          isLoading = false;
          handleFiltros();
        }));
  }

  // Pega os locais e etapas registradas nas inscrições e volta apenas 1 de cada.
  void handleFiltros() {
    // Limpa as variaveis
    filtroBadges = [];
    locaisUnicos = [];
    etapasUnicas = [];

    inscricoes = duplicateItems;
    locaisUnicos.add('Todos');
    etapasUnicas.add('Todos');
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

    filtroBadges.addAll([
      BadgeFiltro(
          items: etapaMenu,
          hintText: 'Etapa',
          selectedItem: etapaTotalFiltro,
          onChange: (value) {
            setState(() {
              etapaTotalFiltro = value == 'Todos' ? null : value;
              etapaFiltro = null;
              localFiltro = null;
              turmaAtribuida = null;
            });
            filtrar({
              'etapa': etapaFiltro,
              'local': localFiltro,
              'etapaTotal': etapaTotalFiltro,
              'turma': turmaAtribuida,
            });
          }),
      BadgeFiltro(
          items: etapasUnicas,
          hintText: 'Etapa Detalhada',
          selectedItem: etapaFiltro,
          onChange: (value) {
            setState(() {
              etapaFiltro = value == 'Todos' ? null : value;
              etapaTotalFiltro = null;
            });
            filtrar({
              'etapa': etapaFiltro,
              'local': localFiltro,
              'etapaTotal': etapaTotalFiltro,
              'turma': turmaAtribuida,
            });
          }),
      BadgeFiltro(
          items: locaisUnicos,
          hintText: 'Local',
          selectedItem: localFiltro,
          onChange: (value) {
            setState(() {
              localFiltro = value == 'Todos' ? null : value;
              etapaTotalFiltro = null;
            });
            filtrar({
              'etapa': etapaFiltro,
              'local': localFiltro,
              'etapaTotal': etapaTotalFiltro,
              'turma': turmaAtribuida,
            });
          }),
      BadgeFiltro(
          items: turmaMenu,
          hintText: 'Turma Atribuida',
          selectedItem: turmaAtribuida,
          onChange: (value) {
            setState(() {
              turmaAtribuida = value;
            });
            filtrar({
              'etapa': etapaFiltro,
              'local': localFiltro,
              'etapaTotal': etapaTotalFiltro,
              'turma': turmaAtribuida,
            });
          }),
    ]);
  }

  void filtrar(Map<String, dynamic> value) {
    inscricoes = duplicateItems.where((e) {
      // Filtrar por 'etapa' se não for nulo, verificando correspondência exata
      bool etapaMatches = value['etapa'] == null || e['etapa'] == value['etapa'];
      
      // Filtrar por 'etapaTotal' se não for nulo, permitindo correspondência parcial
      bool etapaTotalMatches = value['etapaTotal'] == null ||
          (e['etapa'] != null && e['etapa'].contains(value['etapaTotal']));

      // Filtrar por 'local' se não for nulo
      bool localMatches = value['local'] == null || e['local'] == value['local'];

      return etapaMatches && etapaTotalMatches && localMatches;
    }).toList();

    if (value['turma'] != null) {
      inscricoes = inscricoes.where((e) {
        if (value['turma'] == 'Sim') {
          return e['turma'] != null && e['turma']['catequistas'].isNotEmpty;
        } else if (value['turma'] == 'Não') {
          return e['turma'] == null || e['turma']['catequistas'].isEmpty;
        }
        return true; // Se "Todos" ou nenhuma opção, retorna verdadeiro
      }).toList();
    }

    setState(() {});
  }

  void filterSearchResults(String query) {
    setState(() {
      inscricoes = duplicateItems
          .where((item) =>
              item['nome'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  String anoSelecionado = '';

  void onChangeAno(String value) async {
    await getInscricoes(collection: value).then((_) {
      handleFiltros();
    });
    anoSelecionado = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
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
                SelectAno(onChange: onChangeAno),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () async => await exportToExcel(inscricoes),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(255, 140, 235, 143)),
                    child: Image.asset('./assets/images/excel.png', width: 30),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (filtroBadges.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, runAlignment: WrapAlignment.center, children: filtroBadges),
              ),
            if (isLoading)
              const Center(child: Text('Carregando...'))
            else
              Expanded(
                  child: ListaDeInscricoes(
                      inscricoes: inscricoes,
                      accessLevel: widget.accessLevel,
                      anoSelecionado: anoSelecionado,
                      callback: () async => {
                          await getInscricoes().then((_) => setState((){}))
                        },
                      )),
          ],
        ),
      ),
      // floatingActionButton: widget.accessLevel == 2
      //     ? FloatingActionButton.extended(
      //         onPressed: () async {
      //           //var result = await showDialog(context: context, builder: (context) => const InsertManuallyDialog());

      //           if (result == null) return;

      //           if (!context.mounted) return;

      //           if (result) {
      //             // Navega para a página de inserção individual.
      //             Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InscricaoManualPage()));
      //           } else {
      //             // Navega para a página de inserção em massa.
      //           }
      //         },
      //         label: const Text('Inserir', style: TextStyle(fontWeight: FontWeight.bold)),
      //       )
      //     : Container(),
    );
  }
}
