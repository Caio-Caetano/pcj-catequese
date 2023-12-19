import 'package:flutter/material.dart';
import 'package:webapp/controller/turma_controller.dart';
import 'package:webapp/data/turma_repository.dart';

class TurmasPageView extends StatelessWidget {
  const TurmasPageView({super.key});

  @override
  Widget build(BuildContext context) {
    TurmaController turmaController = TurmaController(TurmaRepository());
    return Scaffold(
      body: FutureBuilder(
          future: turmaController.getAllTurmas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Carregando...'));
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text('Sem turmas criadas'));
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Text(snapshot.data?[index].id ?? ''),
              );
            } else {
              return const Center(child: Text('Lista vazia.'));
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Adicionar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}
