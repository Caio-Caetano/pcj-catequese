import 'package:flutter/material.dart';
import 'package:webapp/controller/user_controller.dart';
import 'package:webapp/data/user_repository.dart';

class UserDeleteDialog extends StatelessWidget {
  const UserDeleteDialog({super.key, required this.id, required this.back});
  final String id;
  final VoidCallback back;

  @override
  Widget build(BuildContext context) {
    final userController = UserController(UserRepository());
    return AlertDialog(
      title: const Text('Deletar o usuário'),
      content: const Text('Você está prestes a deletar a inscrição, tem certeza disso?'),
      actions: [
        ElevatedButton(onPressed: () async => await userController.deleteUsuario(id).then((value) => back()), child: const Text('Deletar')),
        ElevatedButton(onPressed: () => back(), child: const Text('Cancelar')),
      ],
    );
  }
}