// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:webapp/controller/user_controller.dart';
import 'package:webapp/data/user_repository.dart';
import 'package:webapp/functions/validators/date_validator.dart';
import 'package:webapp/model/user_model.dart';
import 'package:webapp/pages/admin/home/catequistas/dropdown_catequista.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';

class DialogCreateCatequista extends StatefulWidget {
  const DialogCreateCatequista({
    Key? key,
    required this.submit,
    required this.back,
    required this.contextAlt,
    this.isCoord = false,
    this.etapaCoord,
  }) : super(key: key);
  final VoidCallback submit;
  final VoidCallback back;
  final BuildContext contextAlt;
  final bool? isCoord;
  final String? etapaCoord;

  @override
  State<DialogCreateCatequista> createState() => _DialogCreateCatequistaState();
}

class _DialogCreateCatequistaState extends State<DialogCreateCatequista> {
  final controllerNome = TextEditingController();
  final controllerTelefone = TextEditingController();
  final controllerDtNascimento = TextEditingController();
  final controllerUsuario = TextEditingController();
  final controllerSenha = TextEditingController();

  int? accessLevel;

  List<DropdownMenuItem<int>> levelMenu = const [
    DropdownMenuItem(value: 0, child: Text('Catequista', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 1, child: Text('Coordenador', style: TextStyle(fontSize: 14))),
  ];

  String? coordEtapa;

  List<DropdownMenuItem<String>> etapaMenu = const [
    DropdownMenuItem(value: 'Eucaristia', child: Text('Eucaristia', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Crisma', child: Text('Crisma', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Jovens', child: Text('Jovens', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Adultos', child: Text('Adultos', style: TextStyle(fontSize: 14))),
  ];

  final UserController userController = UserController(UserRepository());
  UserModel userModel = UserModel();

  ValueNotifier<String> retornoEtapa = ValueNotifier<String>('');

  final GlobalKey<FormState> key = GlobalKey<FormState>();
  var maskFormatterDt = MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  var maskFormatterCel = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    if (widget.isCoord!) accessLevel = 0;
    if (widget.etapaCoord != null) coordEtapa = widget.etapaCoord;
    return AlertDialog(
      title: const Text('Editar a inscrição'),
      content: Form(
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldCustom(
              controller: controllerNome,
              labelText: 'Nome',
              hintText: 'Digite o nome do catequista',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '⚠️ Este campo é obrigatório.';
                }
                return null;
              },
            ),
            TextFieldCustom(
              controller: controllerTelefone,
              labelText: 'Telefone',
              formatter: [maskFormatterCel],
              hintText: 'Digite o telefone do catequista',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '⚠️ Este campo é obrigatório.';
                }
                return null;
              },
            ),
            TextFieldCustom(
              controller: controllerDtNascimento,
              labelText: 'Data de Nascimento',
              hintText: 'Digite a data de nascimento do catequista',
              formatter: [maskFormatterDt],
              validator: (value) => checkDate(maskFormatterDt.getMaskedText()),
            ),
            TextFieldCustom(
              controller: controllerUsuario,
              labelText: 'Usuário',
              hintText: 'Digite usuario de acesso do catequista',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '⚠️ Este campo é obrigatório.';
                }
                return null;
              },
            ),
            TextFieldCustom(
              controller: controllerSenha,
              labelText: 'Senha',
              hintText: 'Crie uma senha de acesso',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '⚠️ Este campo é obrigatório.';
                }
                return null;
              },
            ),
            if (!widget.isCoord!)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Escolha um nível', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
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
                      validator: (value) => value == null ? "⚠️ É necessário escolher uma opção." : null,
                      dropdownColor: Colors.grey[400],
                      value: accessLevel,
                      onChanged: (int? newValue) {
                        setState(() {
                          accessLevel = newValue!;
                        });
                      },
                      items: levelMenu),
                ],
              ),
            if (accessLevel != null)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Qual etapa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
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
                      validator: (value) => value == null ? "⚠️ É necessário escolher uma opção." : null,
                      dropdownColor: Colors.grey[400],
                      value: coordEtapa,
                      onChanged: (String? newValue) {
                        setState(() {
                          coordEtapa = newValue!;
                        });
                      },
                      items: widget.etapaCoord != null
                          ? [
                              DropdownMenuItem(value: coordEtapa, child: Text(coordEtapa ?? '', style: const TextStyle(fontSize: 14))),
                            ]
                          : etapaMenu),
                ],
              ),
            if (coordEtapa != null && accessLevel == 0) DropdownCatequista(etapa: coordEtapa!, retornoEtapa: retornoEtapa),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              if (key.currentState!.validate()) {
                userModel.nome = controllerNome.text.toLowerCase();
                userModel.dtNascimento = maskFormatterDt.getMaskedText();
                userModel.telefone = maskFormatterCel.getMaskedText();
                userModel.username = controllerUsuario.text.toLowerCase();
                userModel.senha = controllerSenha.text.toLowerCase();
                userModel.level = accessLevel;
                userModel.etapaCoord = coordEtapa;
                userModel.etapa = retornoEtapa.value;

                ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Carregando...'));

                final result = await userController.createUser(userModel);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }

                if (result.length == 20) {
                  widget.submit();
                } else {
                  widget.back();
                }
              }
            },
            child: const Text('Criar')),
        ElevatedButton(onPressed: () => widget.back(), child: const Text('Cancelar')),
      ],
    );
  }
}
