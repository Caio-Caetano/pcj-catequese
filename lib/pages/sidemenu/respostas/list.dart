import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toastification/toastification.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/controller/turma_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/data/turma_repository.dart';
import 'package:webapp/model/inscricao_model.dart';
import 'package:webapp/model/turma_model.dart';
import 'package:webapp/pages/sidemenu/respostas/custom_pager.dart';
import 'package:webapp/pages/sidemenu/respostas/datasource.dart';
import 'package:webapp/pages/widgets/dialog_archive_inscricao.dart';
import 'package:webapp/pages/widgets/dialog_delete.dart';

// Widget criarListaInscricoes(List<Map<String, dynamic>>? inscricoes,
//         Function() setstate, int accessLevel) =>
//     inscricoes!.isEmpty
//         ? const Text('Sem inscrições')
//         : Expanded(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: inscricoes.length,
//               itemBuilder: (context, index) {
//                 return cardResposta(
//                     inscricao: inscricoes[index],
//                     context: context,
//                     setstate: () => setstate(),
//                     accessLevel: accessLevel);
//               },
//             ),
//           );

class ListaDeInscricoes extends StatefulWidget {
  final List<Map<String, dynamic>>? inscricoes;
  final int accessLevel;
  final String anoSelecionado;
  final VoidCallback callback;
  const ListaDeInscricoes(
      {super.key,
      this.inscricoes,
      required this.accessLevel,
      required this.anoSelecionado, required this.callback});

  @override
  State<ListaDeInscricoes> createState() => _ListaDeInscricoesState();
}

class _ListaDeInscricoesState extends State<ListaDeInscricoes> {
  late RespostasController _respostasController;
  late TurmaController _turmaController;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late InscricoesDataSource _source;
  bool _initialized = false;
  PaginatorController? _controller;

  @override
  void initState() {
    super.initState();
    if (!_initialized) {
      _controller = PaginatorController();

      _sortColumnIndex = 0;

      _initialized = true;

      _source = _buildDataSource(); // Inicializa o DataSource

      _respostasController = RespostasController(RespostasRepository());
      _turmaController = TurmaController(TurmaRepository());

      // Adiciona listener para mudanças na seleção de linhas
      _source.addListener(() {
        setState(() {}); // Atualiza estado para refletir ações
      });

      _source.unselectAll();
    }
  }

  Widget _geraAcoes(InscricaoModel model) {
    final RespostasController controller =
        RespostasController(RespostasRepository());
    return Row(
      children: [
        Tooltip(
          message: 'Arquivar',
          child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return DialogArchiveInscricao(
                      nome: model.nome ?? '',
                      onSubmit: (reason) async {
                        await controller
                            .archiveInscricao(
                                model.id ?? '',
                                reason,
                                model.archived == null
                                    ? false
                                    : model.archived?['isNowArchived'])
                            .then((value) {
                          if (context.mounted) {
                            Navigator.pop(context, value);
                          }
                        });
                      },
                    );
                  }).then((value) {
                if (context.mounted) {
                  value == null || !value
                      ? toastification.show(
                          context: context,
                          type: ToastificationType.warning,
                          style: ToastificationStyle.minimal,
                          title: const Text('Ação cancelada.'),
                          autoCloseDuration: const Duration(seconds: 5),
                          alignment: Alignment.bottomRight,
                        )
                      : toastification.show(
                          context: context,
                          type: ToastificationType.success,
                          style: ToastificationStyle.minimal,
                          title: const Text('📁 Arquivado com sucesso.'),
                          autoCloseDuration: const Duration(seconds: 5),
                          alignment: Alignment.bottomRight,
                        );
                }
                widget.callback();
              });
            },
            icon: const Icon(Icons.archive, color: Colors.blueGrey),
          ),
        ),
        Tooltip(
          message: 'Deletar',
          child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return deleteDialog(
                        id: model.id ?? '',
                        submit: () {
                          Navigator.pop(context, true);
                        },
                        back: () => Navigator.pop(context, false));
                  }).then((value) {
                if (context.mounted) {
                  value == null || !value
                      ? toastification.show(
                          context: context,
                          type: ToastificationType.warning,
                          style: ToastificationStyle.minimal,
                          title: const Text('Ação cancelada.'),
                          autoCloseDuration: const Duration(seconds: 5),
                          alignment: Alignment.bottomRight,
                        )
                      : toastification.show(
                          context: context,
                          type: ToastificationType.success,
                          style: ToastificationStyle.minimal,
                          title: const Text('❌ Inscrição deletada.'),
                          autoCloseDuration: const Duration(seconds: 5),
                          alignment: Alignment.bottomRight,
                        );
                }
                widget.callback();
              });
            },
            icon: const Icon(Icons.delete_forever, color: Colors.red),
          ),
        )
      ],
    );
  }

  InscricoesDataSource _buildDataSource() {
    return InscricoesDataSource(
      context,
      InscricaoModel.fromMapList(widget.inscricoes!),
      _geraAcoes,
      widget.accessLevel,
    );
  }

  @override
  void didUpdateWidget(covariant ListaDeInscricoes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.inscricoes != widget.inscricoes) {
      // Atualiza o DataSource se as inscrições mudarem
      _source = _buildDataSource();
      _source.unselectAll();
      _source.addListener(() {
        setState(() {});
      });
    }
  }

  void sort<T>(
    Comparable<T> Function(InscricaoModel i) getField,
    int columnIndex,
    bool ascending,
  ) {
    _source.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    _source.dispose();
    super.dispose();
  }

  List<Widget> _buildActions(BuildContext context) {
    List<Widget> actions = [];
    final selectedRows = _source.inscricoes.where((i) => i.selected).toList();

    // Verificar se todas as inscrições têm a mesma etapa
    if (selectedRows.isNotEmpty) {
      final primeiraEtapa = selectedRows.first.etapa;
      final todasMesmasEtapas =
          selectedRows.every((i) => i.etapa == primeiraEtapa);

      final collSelected = widget.anoSelecionado == ''
          ? 'inscricoes2025'
          : widget.anoSelecionado;

      if (todasMesmasEtapas && collSelected == 'inscricoes2025') {
        // Adicione o widget desejado
        actions.add(
          FutureBuilder(
              future: _turmaController.getTurmas(etapa: selectedRows[0].etapa!),
              builder: (context, snapshot) {
                return PopupMenuButton(
                    icon: const Icon(Icons.group_add),
                    enabled:
                        !(snapshot.connectionState == ConnectionState.waiting),
                    tooltip: snapshot.connectionState == ConnectionState.waiting
                        ? 'Carregando'
                        : 'Atribuir turma',
                    onSelected: (value) {
                      for (var i in selectedRows) {
                        handleClick(value, i.id!).then((resp) {
                          if (context.mounted) {
                            toastification.show(
                              context: context,
                              type: resp
                                  ? ToastificationType.success
                                  : ToastificationType.error,
                              style: ToastificationStyle.minimal,
                              icon: resp
                                  ? const Icon(
                                      Icons.check_circle_outline_rounded)
                                  : const Icon(Icons.cancel_outlined),
                              title: resp
                                  ? Text('${i.nome} adicionado a turma!')
                                  : Text(
                                      'Não foi possível adicionar a turma: ${i.nome}.'),
                              autoCloseDuration: const Duration(seconds: 10),
                              alignment: Alignment.bottomRight,
                            );
                          }
                        });
                      }
                    },
                    itemBuilder: (context) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? [
                              PopupMenuItem<TurmaModel>(
                                  value: TurmaModel(),
                                  child: Text('Nulo',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall))
                            ]
                          : snapshot.data!
                              .where((e) => e.catequistas!.isNotEmpty)
                              .map((e) => PopupMenuItem<TurmaModel>(
                                  value: e,
                                  child: Text(
                                      '${e.catequistas![0]} | ${e.local}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall)))
                              .toList();
                    });
              }),
        );
      }
    }

    actions.add(
      Tooltip(
        message: 'Transferir',
        child: IconButton(
          icon: const Icon(Icons.forward, color: Color(0xFF003e86)),
          onPressed: () async {
            final response = await _respostasController
                .inserirInscricao(selectedRows, collection: 'inscricoes2025');

            if (context.mounted) {
              for (var resp in response) {
                bool success = resp['sucesso'];
                toastification.show(
                  context: context,
                  type: success
                      ? ToastificationType.success
                      : ToastificationType.error,
                  style: ToastificationStyle.minimal,
                  icon: success
                      ? const Icon(Icons.check_circle_outline_rounded)
                      : const Icon(Icons.cancel_outlined),
                  title: success
                      ? const Text('Transferido com sucesso!')
                      : Text('Não foi possível transferir: ${resp['nome']}.'),
                  description: success
                      ? Text('${resp['id']}')
                      : Text('Motivo: ${resp['message']}'),
                  autoCloseDuration: const Duration(seconds: 10),
                  alignment: Alignment.bottomRight,
                );
              }
            }

            _source.unselectAll();
          },
        ),
      ),
    );

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      PaginatedDataTable2(
        controller: _controller,
        hidePaginator: true,
        availableRowsPerPage: const [2, 5, 10, 30, 100],
        horizontalMargin: 20,
        checkboxHorizontalMargin: 0,
        columnSpacing: 0,
        dataRowHeight: 65,
        wrapInCard: false,
        renderEmptyRowsInTheEnd: false,
        actions: _source.selectedRowCount > 0 ? _buildActions(context) : [],
        headingRowColor:
            WidgetStateColor.resolveWith((states) => Colors.grey[200]!),
        header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Inscrições'),
              Pager(controller: _controller!)
            ]),
        rowsPerPage: _rowsPerPage,
        minWidth: 800,
        fit: FlexFit.tight,
        border: TableBorder(
            top: const BorderSide(color: Colors.black),
            bottom: BorderSide(color: Colors.grey[300]!),
            left: BorderSide(color: Colors.grey[300]!),
            right: BorderSide(color: Colors.grey[300]!),
            verticalInside: BorderSide(color: Colors.grey[300]!),
            horizontalInside: const BorderSide(color: Colors.grey, width: 1)),
        onRowsPerPageChanged: (value) {
          _rowsPerPage = value!;
        },
        initialFirstRowIndex: 0,
        onPageChanged: (rowIndex) {},
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        sortArrowIcon: Icons.keyboard_arrow_up, // custom arrow
        sortArrowAnimationDuration:
            const Duration(milliseconds: 0), // custom animation duration
        onSelectAll: _source.selectAll,
        dataTextStyle: Theme.of(context).textTheme.labelSmall,
        columns: [
          DataColumn(
            label: const Text('Nome'),
            onSort: (columnIndex, ascending) =>
                sort<String>((i) => i.nome ?? '', columnIndex, ascending),
          ),
          const DataColumn2(
            size: ColumnSize.S,
            label: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text('Idade'),
            ),
          ),
          DataColumn(
            label: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Local'),
            ),
            onSort: (columnIndex, ascending) =>
                sort<String>((i) => i.local ?? '', columnIndex, ascending),
          ),
          DataColumn(
            label: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Etapa'),
            ),
            onSort: (columnIndex, ascending) =>
                sort<String>((i) => i.etapa ?? '', columnIndex, ascending),
          ),
          const DataColumn(
            label: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Ações'),
            ),
          ),
        ],
        source: _source,
      ),
      Positioned(bottom: 16, child: CustomPager(_controller!))
    ]);
  }
}

Future<bool> handleClick(TurmaModel turma, String id) async {
  RespostasController respostasController =
      RespostasController(RespostasRepository());
  return await respostasController.updateInscricaoTurma(id, turma);
}
