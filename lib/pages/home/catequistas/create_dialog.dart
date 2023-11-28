import 'package:flutter/material.dart';
import 'package:webapp/controller/user_controller.dart';
import 'package:webapp/data/user_repository.dart';
import 'package:webapp/model/user_model.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';

Widget createDialog({required VoidCallback submit, required VoidCallback back, required BuildContext context}) {
  final controllerNome = TextEditingController();
  final controllerSenha = TextEditingController();

  int? accessLevel;

  List<DropdownMenuItem<int>> levelMenu = const [
    DropdownMenuItem(value: 0, child: Text('Catequista', style: TextStyle(fontSize: 14))),
    DropdownMenuItem(value: 1, child: Text('Coordenador', style: TextStyle(fontSize: 14))),
  ];

  final UserController userController = UserController(UserRepository());
  UserModel userModel = UserModel();

  return AlertDialog(
    title: const Text('Editar a inscrição'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFieldCustom(
          controller: controllerNome,
          labelText: 'Nome',
          hintText: 'Digite nome do catequista',
        ),
        TextFieldCustom(
          controller: controllerSenha,
          labelText: 'Senha',
          hintText: 'Crie uma senha de acesso',
        ),
        StatefulBuilder(builder: (context, setState) {
          return Column(
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
          );
        })
      ],
    ),
    actions: [
      ElevatedButton(
          onPressed: () async {
            userModel.username = controllerNome.text.toLowerCase();
            userModel.senha = controllerSenha.text.toLowerCase();
            userModel.level = accessLevel;

            ScaffoldMessenger.of(context).showSnackBar(createSnackBar('Carregando...'));

            final result = await userController.createUser(userModel);

            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }

            if (result.length == 20) {
              submit();
            } else {
              back();
            }
          },
          child: const Text('Criar')),
      ElevatedButton(onPressed: () => back(), child: const Text('Cancelar')),
    ],
  );
}
