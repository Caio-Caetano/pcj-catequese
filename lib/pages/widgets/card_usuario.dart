import 'package:flutter/material.dart';

Widget cardUsuario({required Map<String, dynamic> usuario}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: const Border(left: BorderSide(width: 8.0, color: Colors.green)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nome: ${usuario['nome']}', style: const TextStyle(fontSize: 18)),
            Text('Telefone: ${usuario['telefone']}', style: const TextStyle(fontSize: 18)),
            Text('Data de nascimento: ${usuario['dtNascimento']}', style: const TextStyle(fontSize: 18)),
            Text('Usuário: ${usuario['username']}', style: const TextStyle(fontSize: 15)),
            Text('Coordenador: ${(usuario['level'] == 1 || usuario['level'] == 2) ? 'Sim - ${usuario['etapaCoord']}' : 'Não'}', style: const TextStyle(fontSize: 15)),
            Text('Etapa: ${usuario['etapa'] ?? 'Sem etapa definida'}', style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    ),
  );
}
