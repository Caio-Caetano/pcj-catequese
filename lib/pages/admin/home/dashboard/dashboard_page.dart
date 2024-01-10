import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';

class DashboardAdminPage extends StatelessWidget {
  const DashboardAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    RespostasController controllerRespostas = RespostasController(RespostasRepository());

    int totalEucaristia = 0;
    int totalEucaristia1 = 0;
    int totalEucaristia2 = 0;
    int totalEucaristia3 = 0;

    int totalCrisma = 0;
    int totalCrisma1 = 0;
    int totalCrisma2 = 0;
    int totalCrisma3 = 0;

    int totalJovens = 0;
    int totalAdultos = 0;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text('Dashboard', style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: FutureBuilder(
              future: controllerRespostas.getRespostas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('Carregando...'));
                }

                if (snapshot.data != null) {
                  for (var element in snapshot.data!) {
                    if (element['etapa'].contains('Eucaristia')) {
                      totalEucaristia++;
                    } else if (element['etapa'].contains('Crisma')) {
                      totalCrisma++;
                    } else if (element['etapa'].contains('Jovens')) {
                      totalJovens++;
                    } else if (element['etapa'].contains('Adultos')) {
                      totalAdultos++;
                    }
                  }
                }

                if (snapshot.data != null) {
                  for (var element in snapshot.data!) {
                    switch (element['etapa']) {
                      case '1º Etapa - Eucaristia':
                        totalEucaristia1++;
                        break;
                      case '2º Etapa - Eucaristia':
                        totalEucaristia2++;
                        break;
                      case '3º Etapa - Eucaristia':
                        totalEucaristia3++;
                        break;
                      case '1º Etapa - Crisma':
                        totalCrisma1++;
                        break;
                      case '2º Etapa - Crisma':
                        totalCrisma2++;
                        break;
                      case '3º Etapa - Crisma':
                        totalCrisma3++;
                        break;
                      default:
                        break;
                    }
                  }
                }

                return Wrap(
                  spacing: 10.0,
                  runSpacing: 5.0,
                  alignment: WrapAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Detalhado', style: Theme.of(context).textTheme.titleLarge),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('$totalEucaristia1 :: 1º Etapa - Eucaristia', style: Theme.of(context).textTheme.bodyMedium),
                                    const SizedBox(height: 10),
                                    Text('$totalEucaristia2 :: 2º Etapa - Eucaristia', style: Theme.of(context).textTheme.bodyMedium),
                                    const SizedBox(height: 10),
                                    Text('$totalEucaristia3 :: 3º Etapa - Eucaristia', style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              )),
                      child: CircularPercentIndicator(
                        radius: 50,
                        animation: true,
                        percent: 1.0,
                        progressColor: Colors.green,
                        center: Text('$totalEucaristia', style: Theme.of(context).textTheme.titleMedium),
                        footer: const Text('Eucaristia'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Detalhado', style: Theme.of(context).textTheme.titleLarge),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('$totalCrisma1 :: 1º Etapa - Crisma', style: Theme.of(context).textTheme.bodyMedium),
                                    const SizedBox(height: 10),
                                    Text('$totalCrisma2 :: 2º Etapa - Crisma', style: Theme.of(context).textTheme.bodyMedium),
                                    const SizedBox(height: 10),
                                    Text('$totalCrisma3 :: 3º Etapa - Crisma', style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              )),
                      child: CircularPercentIndicator(
                        radius: 50,
                        animation: true,
                        percent: 1.0,
                        progressColor: Colors.blue,
                        center: Text('$totalCrisma', style: Theme.of(context).textTheme.titleMedium),
                        footer: const Text('Crisma'),
                      ),
                    ),
                    CircularPercentIndicator(
                      radius: 50,
                      animation: true,
                      percent: 1.0,
                      progressColor: Colors.yellow,
                      center: Text('$totalJovens', style: Theme.of(context).textTheme.titleMedium),
                      footer: const Text('Jovens'),
                    ),
                    CircularPercentIndicator(
                      radius: 50,
                      animation: true,
                      percent: 1.0,
                      progressColor: Colors.indigo,
                      center: Text('$totalAdultos', style: Theme.of(context).textTheme.titleMedium),
                      footer: const Text('Adultos'),
                    ),
                    CircularPercentIndicator(
                      radius: 50,
                      animation: true,
                      percent: 1.0,
                      progressColor: Colors.deepOrange,
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
