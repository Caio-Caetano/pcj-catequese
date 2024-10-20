import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webapp/controller/horarios_locais_controller.dart';
import 'package:webapp/data/horarios_locais_repository.dart';
import 'package:webapp/pages/admin/home/horarios/tile_horario.dart';
import 'package:webapp/pages/widgets/dropdown_custom.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';

class ExpansionLocais extends StatefulWidget {
  const ExpansionLocais({super.key, required this.etapa});
  final String etapa;

  @override
  State<ExpansionLocais> createState() => _ExpansionLocaisState();
}

class _ExpansionLocaisState extends State<ExpansionLocais> {
  final HorariosLocaisController horariosLocaisController = HorariosLocaisController(HorariosLocaisRepository());
  final ValueNotifier<String> valueNotifier = ValueNotifier<String>('');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: horariosLocaisController.getHorariosLocais(widget.etapa),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Carregando horários...', style: Theme.of(context).textTheme.labelSmall);
        } else {
          return Column(
            children: [
              if (snapshot.data!.isEmpty || !snapshot.hasData)
                Text('Sem horários definidos.', style: Theme.of(context).textTheme.labelSmall)
              else
                for (var item in snapshot.data!)
                  TileHorario(
                    item: item,
                    onDelete: () async {
                      ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Deletando horário'));
                      await horariosLocaisController.deleteHorarioLocais(etapa: widget.etapa, horario: item).then((value) => setState(() {}));
                    },
                  ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return _MenuAlertDialog(
                          valueNotifier: valueNotifier,
                          onSubmit: () => Navigator.pop(context, true),
                          onClose: () => Navigator.pop(context, false),
                        );
                      },
                    ).then(
                      (value) async {
                        if (value == null || !value) {
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Ação cancelada.'));
                        } else {
                          await horariosLocaisController.addHorarioLocais(etapa: widget.etapa, horario: valueNotifier.value).then((value) => setState(() {}));
                        }
                      },
                    );
                  },
                  child: const Text('Adicionar'),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class _MenuAlertDialog extends StatefulWidget {
  final VoidCallback onSubmit;
  final VoidCallback onClose;
  final ValueNotifier<String> valueNotifier;
  const _MenuAlertDialog({required this.onSubmit, required this.onClose, required this.valueNotifier});

  @override
  State<_MenuAlertDialog> createState() => __MenuAlertDialogState();
}

class __MenuAlertDialogState extends State<_MenuAlertDialog> {
  String? diaSemana;

  List<DropdownMenuItem<String>> diaSemanaMenu = const [
    DropdownMenuItem(value: 'Segunda-feira', child: Text('Segunda-feira', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Terça-feira', child: Text('Terça-feira', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Quarta-feira', child: Text('Quarta-feira', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Quinta-feira', child: Text('Quinta-feira', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Sexta-feira', child: Text('Sexta-feira', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Sábado', child: Text('Sábado', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Domingo', child: Text('Domingo', style: TextStyle(fontSize: 14))),
  ];

  String? local;

  List<DropdownMenuItem<String>> localMenu = const [
    DropdownMenuItem(value: 'Santuário', child: Text('Santuário', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Jd Portugal', child: Text('Jd Portugal', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Centro Past. Pe. Wagner', child: Text('Centro Past. Pe. Wagner', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Outro', child: Text('Outro', style: TextStyle(fontSize: 14))),
  ];

  var maskFormatter = MaskTextInputFormatter(mask: '##', filter: {"#": RegExp(r'[0-9]')});

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  final horaController = TextEditingController();
  final minutoController = TextEditingController();

  final horaFinalController = TextEditingController();
  final minutoFinalController = TextEditingController();

  final outroLocalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adicionar Horário', style: Theme.of(context).textTheme.bodyMedium),
      content: Form(
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonCustom(
              label: 'Dia da semana',
              value: diaSemana,
              items: diaSemanaMenu,
              onChanged: (String? newValue) {
                setState(() {
                  diaSemana = newValue!;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFieldCustom(
                    controller: horaController,
                    labelText: 'Hora',
                    formatter: [maskFormatter],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Digite um valor entre 00 e 23';
                      if (int.parse(value) > 23 || int.parse(value) < 0) return 'Apenas valores entre 00 e 23';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFieldCustom(
                    controller: minutoController,
                    labelText: 'Minuto',
                    formatter: [maskFormatter],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Digite um valor entre 00 e 59';
                      if (int.parse(value) > 59 || int.parse(value) < 0) return 'Apenas valores entre 00 e 59';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFieldCustom(
                    controller: horaFinalController,
                    labelText: 'Hora Final',
                    formatter: [maskFormatter],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Digite um valor entre 00 e 23';
                      if (int.parse(value) > 23 || int.parse(value) < 0) return 'Apenas valores entre 00 e 23';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFieldCustom(
                    controller: minutoFinalController,
                    labelText: 'Minuto Final',
                    formatter: [maskFormatter],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Digite um valor entre 00 e 59';
                      if (int.parse(value) > 59 || int.parse(value) < 0) return 'Apenas valores entre 00 e 59';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            DropdownButtonCustom(
              label: 'Local do encontro',
              value: local,
              items: localMenu,
              onChanged: (String? newValue) {
                setState(() {
                  local = newValue!;
                  outroLocalController.clear();
                });
              },
            ),
            if (local == 'Outro')
              TextFieldCustom(
                controller: outroLocalController,
                labelText: 'Local',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Digite algum local';
                  return null;
                },
              ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: widget.onClose, child: const Text('Cancelar')),
        ElevatedButton(
            onPressed: () {
              if (key.currentState!.validate()) {
                widget.valueNotifier.value = '$diaSemana as ${horaController.text}:${minutoController.text}h as ${horaFinalController.text}:${minutoFinalController.text}h no ${local == 'Outro' ? outroLocalController.text : local}';
                widget.onSubmit();
              }
            },
            child: const Text('Salvar')),
      ],
    );
  }
}
