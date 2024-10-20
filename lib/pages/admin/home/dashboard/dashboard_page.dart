import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/enums.dart';
import 'package:webapp/model/dashboard_model.dart';
import 'package:webapp/pages/widgets/select_ano.dart';

import 'chart.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  String anoSelecionado = dotenv.env['INSCRICAO'] ?? '';

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

    void onChangeAno(String value) async {      
      setState(() {
        anoSelecionado = value;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text('Dashboard', style: Theme.of(context).textTheme.titleLarge),
          SelectAno(onChange: onChangeAno),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: controllerRespostas.getRespostas(collection: anoSelecionado),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('Carregando...'));
                }

                if (snapshot.data != null) {
                  for (var element in snapshot.data!) {
                    // Incrementa a quantidade para cada etapa principal
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
                  
                for (var element in snapshot.data!) {
                  // Incrementa a quantidade para as listaInscricoesDashboardModel específicas
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

              List<InscricoesDashboardModel> listaInscricoesTotaisDashboardModel = [
                InscricoesDashboardModel(titulo: 'Eucaristia', quantidade: totalEucaristia),
                InscricoesDashboardModel(titulo: 'Crisma', quantidade: totalCrisma),
                InscricoesDashboardModel(titulo: 'Jovens', quantidade: totalJovens),
                InscricoesDashboardModel(titulo: 'Adultos', quantidade: totalAdultos),
              ];

              List<InscricoesDashboardModel> listaInscricoesEucaristia = [
                InscricoesDashboardModel(titulo: '1º Etapa - Eucaristia', quantidade: totalEucaristia1),
                InscricoesDashboardModel(titulo: '2º Etapa - Eucaristia', quantidade: totalEucaristia2),
                InscricoesDashboardModel(titulo: '3º Etapa - Eucaristia', quantidade: totalEucaristia3),
              ];

              List<InscricoesDashboardModel> listaInscricoesCrisma = [
                InscricoesDashboardModel(titulo: '1º Etapa - Crisma', quantidade: totalCrisma1),
                InscricoesDashboardModel(titulo: '2º Etapa - Crisma', quantidade: totalCrisma2),
                InscricoesDashboardModel(titulo: '3º Etapa - Crisma', quantidade: totalCrisma3),
              ];

                return SingleChildScrollView(
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      ChartDashboard(inscricoesDashboardModel: listaInscricoesTotaisDashboardModel, titulo: 'Inscrições por turma', modeloGrafico: ModeloChart.donut), // Por turma
                      ChartDashboard(inscricoesDashboardModel: listaInscricoesEucaristia, titulo: '1º Eucaristia', modeloGrafico: ModeloChart.column), // Eucarista
                      ChartDashboard(inscricoesDashboardModel: listaInscricoesCrisma, titulo: 'Crisma', modeloGrafico: ModeloChart.column), // Crisma
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
