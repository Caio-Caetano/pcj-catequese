import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webapp/controller/user_controller.dart';
import 'package:webapp/data/user_repository.dart';
import 'package:webapp/model/user_model.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';

class UserEditDialog extends StatefulWidget {
  const UserEditDialog({super.key, required this.back, required this.map});
  final VoidCallback back;
  final Map<String, dynamic> map;

  @override
  State<UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<UserEditDialog> {
  final controllerNome = TextEditingController();
  final controllerTelefone = TextEditingController();
  final controllerUsuario = TextEditingController();
  final controllerSenha = TextEditingController();

  int? accessLevel;

  List<DropdownMenuItem<int>> levelMenu = const [
    DropdownMenuItem(value: 0, child: Text('Catequista', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 1, child: Text('Coordenador', style: TextStyle(fontSize: 14))),
  ];

  String? coordEtapa;

  List<DropdownMenuItem<String>> etapaMenu = const [
    DropdownMenuItem(value: 'Eucaristia', child: Text('Eucarista', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Crisma', child: Text('Crisma', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Jovens', child: Text('Jovens', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 'Adultos', child: Text('Adultos', style: TextStyle(fontSize: 14))),
  ];

  final UserController userController = UserController(UserRepository());
  UserModel userModel = UserModel();

  var maskFormatterCel = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar catequista'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldCustom(
            controller: controllerNome,
            labelText: 'Nome',
            hintText: 'Digite o nome do catequista',
          ),
          TextFieldCustom(
            controller: controllerTelefone,
            labelText: 'Telefone',
            formatter: [maskFormatterCel],
            hintText: 'Digite o telefone do catequista',
          ),
          TextFieldCustom(
            controller: controllerUsuario,
            labelText: 'Usuário',
            hintText: 'Digite usuario de acesso do catequista',
          ),
          TextFieldCustom(
            controller: controllerSenha,
            labelText: 'Senha',
            hintText: 'Crie uma senha de acesso',
          ),
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
          if (accessLevel == 1)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Qual coordenação', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                    dropdownColor: Colors.grey[400],
                    value: coordEtapa,
                    onChanged: (String? newValue) {
                      setState(() {
                        coordEtapa = newValue!;
                      });
                    },
                    items: etapaMenu),
              ],
            ),
        ],
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              userModel.id = widget.map['id'];
              userModel.nome = widget.map['nome'];
              userModel.telefone = widget.map['telefone'];
              userModel.username = widget.map['username'];
              userModel.level = widget.map['level'];
              userModel.etapaCoord = widget.map['etapaCoord'];
              userModel.dtNascimento = widget.map['dtNascimento'];

              userModel.senha = controllerSenha.text.toLowerCase();

              controllerNome.text.toLowerCase() != widget.map['nome'] && controllerNome.text.isNotEmpty ? userModel.nome = controllerNome.text.toLowerCase() : null;
              maskFormatterCel.getMaskedText() != widget.map['telefone'] && maskFormatterCel.getMaskedText().isNotEmpty ? userModel.telefone = maskFormatterCel.getMaskedText() : null;
              controllerUsuario.text.toLowerCase() != widget.map['username'] && controllerUsuario.text.isNotEmpty ? userModel.username = controllerUsuario.text.toLowerCase() : null;
              accessLevel != widget.map['level'] && accessLevel != null ? userModel.level = accessLevel : null;
              coordEtapa != widget.map['etapaCoord'] && coordEtapa != null ? userModel.etapaCoord = coordEtapa : null;

              ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Carregando...'));

              await userController.editUser(userModel);

              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }

              widget.back();
            },
            child: const Text('Editar')),
        ElevatedButton(onPressed: () => widget.back(), child: const Text('Cancelar')),
      ],
    );
  }
}
