import 'package:flutter/material.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';

Widget deleteDialog(String id, VoidCallback back) {
  final RespostasController controller = RespostasController(RespostasRepository());
  return AlertDialog(
    title: const Text('Deletar inscrição'),
    content: const Text('Você está prestes a deletar a inscrição, tem certeza disso?'),
    actions: [
      ElevatedButton(onPressed: () async => await controller.deletarInscricao(id).then((value) => back()), child: const Text('Deletar')),
      ElevatedButton(onPressed: () => back(), child: const Text('Cancelar')),
    ],
  );
}