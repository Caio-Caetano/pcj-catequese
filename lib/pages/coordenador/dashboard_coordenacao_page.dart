// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';

class DashboardCoordenacaoPage extends StatelessWidget {
  final String? etapa;
  const DashboardCoordenacaoPage({
    Key? key,
    required this.etapa,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RespostasController controllerRespostas = RespostasController(RespostasRepository());

    int total1 = 0;
    int total2 = 0;
    int total3 = 0;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text('Dashboard', style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: FutureBuilder(
              future: controllerRespostas.getRespostas(etapa: etapa),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('Carregando...'));
                }

                if (snapshot.data != null) {
                  for (var element in snapshot.data!) {
                    if (element['etapa'].contains('1º Etapa')) {
                      total1++;
                    } else if (element['etapa'].contains('2º Etapa')) {
                      total2++;
                    } else if (element['etapa'].contains('3º Etapa')) {
                      total3++;
                    }
                  }
                }

                return etapa == 'Jovens' || etapa == 'Adultos'
                    ? CircularPercentIndicator(
                        radius: 50,
                        animation: true,
                        percent: 1.0,
                        progressColor: Colors.redAccent,
                        center: Text('${snapshot.data?.length}', style: Theme.of(context).textTheme.titleMedium),
                        footer: const Text('Total'),
                      )
                    : Wrap(
                        spacing: 10.0,
                        runSpacing: 5.0,
                        alignment: WrapAlignment.center,
                        children: [
                          CircularPercentIndicator(
                            radius: 50,
                            animation: true,
                            percent: 1.0,
                            progressColor: Colors.green,
                            center: Text('$total1', style: Theme.of(context).textTheme.titleMedium),
                            footer: const Text('1º Etapa'),
                          ),
                          CircularPercentIndicator(
                            radius: 50,
                            animation: true,
                            percent: 1.0,
                            progressColor: Colors.green,
                            center: Text('$total2', style: Theme.of(context).textTheme.titleMedium),
                            footer: const Text('2º Etapa'),
                          ),
                          CircularPercentIndicator(
                            radius: 50,
                            animation: true,
                            percent: 1.0,
                            progressColor: Colors.green,
                            center: Text('$total3', style: Theme.of(context).textTheme.titleMedium),
                            footer: const Text('3º Etapa'),
                          ),
                          CircularPercentIndicator(
                            radius: 50,
                            animation: true,
                            percent: 1.0,
                            progressColor: Colors.redAccent,
                            center: Text('${snapshot.data?.length}', style: Theme.of(context).textTheme.titleMedium),
                            footer: const Text('Total'),
                          ),
                        ],
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
