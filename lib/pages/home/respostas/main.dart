import 'package:flutter/material.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/functions/create_excel.dart';
import 'package:webapp/pages/home/respostas/card.dart';

class RepostasPageView extends StatelessWidget {
  const RepostasPageView({super.key});

  @override
  Widget build(BuildContext context) {
    RespostasController controllerRespostas = RespostasController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: controllerRespostas.getAllRespostas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Carregando inscrições'));
            }

            final List<Map<String, dynamic>>? inscricoes;

            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao capturar as respostas.'));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Sem dados.'));
            } else {
              inscricoes = snapshot.data;
              return Column(
                children: [
                  InkWell(
                    onTap: () async => await exportToExcel(inscricoes!),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color.fromARGB(255, 140, 235, 143)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('./assets/images/excel.png', width: 30),
                          const SizedBox(width: 5),
                          const Text('Exportar Excel'),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: inscricoes!.length,
                    itemBuilder: (context, index) {
                      return cardResposta(etapa: inscricoes![index]);
                    },
                  ),
                ],
              );
            }
          }),
    );
  }
}
