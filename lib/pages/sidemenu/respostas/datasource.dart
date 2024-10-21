import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/model/inscricao_model.dart';
import 'package:webapp/pages/widgets/dialog_download_arquivos.dart';
import 'package:webapp/pages/widgets/dialog_view.dart';

class RestorableInscricaoSelections extends RestorableProperty<Set<int>> {
  Set<int> _inscricaoSelections = {};

  bool isSelected(int index) => _inscricaoSelections.contains(index);

  void setinscricoeselections(List<InscricaoModel> desserts) {
    final updatedSet = <int>{};
    for (var i = 0; i < desserts.length; i += 1) {
      var inscricao = desserts[i];
      if (inscricao.selected) {
        updatedSet.add(i);
      }
    }
    _inscricaoSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _inscricaoSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _inscricaoSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _inscricaoSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _inscricaoSelections = value;
  }

  @override
  Object? toPrimitives() => _inscricaoSelections.toList();
}

class InscricoesDataSource extends DataTableSource {
  InscricoesDataSource(
    this.context,
    this.inscricoes,
    this.acoes,
    this.accessLevel, [
    this.hasRowTaps = false,
    this.hasRowHeightOverrides = false,
    this.hasZebraStripes = false,
  ]);

  final BuildContext context;
  final List<InscricaoModel> inscricoes;
  final Widget Function(InscricaoModel) acoes;
  final int accessLevel;

  bool hasRowTaps = false;
  bool hasRowHeightOverrides = false;
  bool hasZebraStripes = false;

  void sort<T>(
      Comparable<T> Function(InscricaoModel i) getField, bool ascending) {
    inscricoes.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedInscricoes(RestorableInscricaoSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < inscricoes.length; i += 1) {
      var inscricao = inscricoes[i];
      if (selectedRows.isSelected(i)) {
        inscricao.selected = true;
        _selectedCount += 1;
      } else {
        inscricao.selected = false;
      }
    }
    notifyListeners();
  }

  String retornaIdade(String dataNascimento) {
    DateTime dtNascFormated = DateFormat("dd/MM/yyyy").parse(dataNascimento);
    DateTime agora = DateTime.now();

    int idade = agora.year - dtNascFormated.year;

    // Verifica se já fez aniversário este ano
    if (agora.month < dtNascFormated.month || 
      (agora.month == dtNascFormated.month && agora.day < dtNascFormated.day)) {
      idade--;
    }

    return idade.toString();
  }

  final RespostasController controller = RespostasController(RespostasRepository());

  @override
  DataRow? getRow(int index, [Color? color]) {
    assert(index >= 0);
    if (index >= inscricoes.length) throw 'index > _inscricoes.length';
    final inscricao = inscricoes[index];
        
    final idade = retornaIdade(inscricao.dataNascimento!);
    return DataRow2.byIndex(
      index: index,
      selected: inscricao.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
              ? WidgetStateProperty.all(Theme.of(context).highlightColor)
              : null),
      onSelectChanged: (value) {
        if (inscricao.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          inscricao.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(inscricao.nome ?? '')),
        DataCell(Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(idade),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(inscricao.local ?? ''),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(inscricao.etapa ?? ''),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(children: [
            Tooltip(
              message: 'Visualizar',
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return viewDialog(
                        inscricao.toMap(),
                        () {
                          Navigator.pop(context);
                        },
                        context,
                      );
                    },
                  );
                },
                icon: const Icon(Icons.visibility, color: Colors.green),
              ),
            ),
            if ((inscricao.batismo != null && inscricao.batismo?['possui']) || (inscricao.eucaristia != null && inscricao.eucaristia?['possui']))
              Tooltip(
                message: 'Documentos',
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return dialogDownloadArquivos(
                          {
                            'batismo': inscricao.batismo,
                            'eucaristia': inscricao.eucaristia,
                          },
                          () { Navigator.pop(context); },
                          context
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.file_present_rounded, color: Colors.blueAccent),
                ),
              ),
            if (accessLevel == 2)
              acoes(inscricao)
            //   Tooltip(
            //     message: 'Arquivar',
            //     child: IconButton(
            //       onPressed: () {
            //         showDialog(
            //             context: context,
            //             builder: (context) {
            //               return DialogArchiveInscricao(
            //                 nome: inscricao.nome ?? '',
            //                 onSubmit: (reason) async {
            //                   await controller
            //                       .archiveInscricao(
            //                           inscricao.id ?? '',
            //                           reason,
            //                           inscricao.archived == null
            //                               ? false
            //                               : inscricao
            //                                   .archived?['isNowArchived'])
            //                       .then((value) {
            //                     if (context.mounted) {
            //                       Navigator.pop(context, value);
            //                     }
            //                   });
            //                 },
            //               );
            //             }).then((value) {
            //           if (context.mounted) {
            //             value == null || !value
            //                 ? toastification.show(
            //                     context: context,
            //                     type: ToastificationType.warning,
            //                     style: ToastificationStyle.minimal,
            //                     title: const Text('Ação cancelada.'),
            //                     autoCloseDuration: const Duration(seconds: 5),
            //                     alignment: Alignment.bottomRight,
            //                   )
            //                 : toastification.show(
            //                     context: context,
            //                     type: ToastificationType.success,
            //                     style: ToastificationStyle.minimal,
            //                     title: const Text('📁 Arquivado com sucesso.'),
            //                     autoCloseDuration: const Duration(seconds: 5),
            //                     alignment: Alignment.bottomRight,
            //                   );
            //           }
            //         });
            //       },
            //       icon: const Icon(Icons.archive, color: Colors.blueGrey),
            //     ),
            //   ),
            // if (accessLevel == 2)
            //   Tooltip(
            //     message: 'Deletar',
            //     child: IconButton(
            //       onPressed: () {
            //         showDialog(
            //             context: context,
            //             builder: (context) {
            //               return deleteDialog(
            //                   id: inscricao.id ?? '',
            //                   submit: () {
            //                     Navigator.pop(context, true);
            //                   },
            //                   back: () => Navigator.pop(context, false));
            //             }).then((value) {
            //           if (context.mounted) {
            //             value == null || !value
            //                 ? toastification.show(
            //                     context: context,
            //                     type: ToastificationType.warning,
            //                     style: ToastificationStyle.minimal,
            //                     title: const Text('Ação cancelada.'),
            //                     autoCloseDuration: const Duration(seconds: 5),
            //                     alignment: Alignment.bottomRight,
            //                   )
            //                 : toastification.show(
            //                     context: context,
            //                     type: ToastificationType.success,
            //                     style: ToastificationStyle.minimal,
            //                     title: const Text('❌ Inscrição deletada.'),
            //                     autoCloseDuration: const Duration(seconds: 5),
            //                     alignment: Alignment.bottomRight,
            //                   );
            //           }
            //         });
            //       },
            //       icon: const Icon(Icons.delete_forever, color: Colors.red),
            //     ),
            //   ),
          ]),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => inscricoes.length;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final inscricao in inscricoes) {
      inscricao.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? inscricoes.length : 0;
    notifyListeners();
  }

  void unselectAll() {
    for (final inscricao in inscricoes) {
      inscricao.selected = false;
    }
    _selectedCount = 0;
    notifyListeners();
  }
}

int _selectedCount = 0;
