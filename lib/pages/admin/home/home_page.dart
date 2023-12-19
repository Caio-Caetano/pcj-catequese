import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/pages/admin/home/catequistas/main_admin.dart';
import 'package:webapp/pages/admin/home/configuracoes/main.dart';
import 'package:webapp/pages/admin/home/horarios/main.dart';
import 'package:webapp/pages/admin/home/respostas/main.dart';
import 'package:webapp/pages/admin/home/turmas/main.dart';
import 'package:webapp/viewmodels/auth_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onLogout});
  final VoidCallback onLogout;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    List<SideMenuItem> items = [
      SideMenuItem(
        title: 'Respostas',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.article),
      ),
      SideMenuItem(
        title: 'Turmas',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.groups),
      ),
      SideMenuItem(
        title: 'Catequistas',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.people),
      ),
      SideMenuItem(
        title: 'Horários e Locais',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.timelapse),
      ),
      SideMenuItem(
        title: 'Avisos',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.connect_without_contact),
      ),
      SideMenuItem(
        title: 'Configurações',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.settings),
      ),
      SideMenuItem(
        builder: (context, displayMode) {
          if (displayMode == SideMenuDisplayMode.open) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await authViewModel.logout();
                    widget.onLogout();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Sair',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: IconButton(
                onPressed: () async {
                  await authViewModel.logout();
                  widget.onLogout();
                },
                icon: const Icon(Icons.logout, color: Colors.red),
              ),
            );
          }
        },
      ),
      SideMenuItem(
        builder: (context, displayMode) {
          RespostasController controllerRespostas = RespostasController(RespostasRepository());
          int totalEucaristia = 0;
          int totalCrisma = 0;
          int totalJovens = 0;
          int totalAdultos = 0;

          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: FutureBuilder(
              future: controllerRespostas.getAllRespostas(),
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

                if (displayMode == SideMenuDisplayMode.open) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LinearPercentIndicator(
                        animation: true,
                        percent: 1.0,
                        progressColor: Colors.green,
                        lineHeight: 8,
                        width: 150,
                        barRadius: const Radius.circular(5),
                        trailing: Text('$totalEucaristia - Eucaristia'),
                      ),
                      const SizedBox(height: 10),
                      LinearPercentIndicator(
                        animation: true,
                        percent: 1.0,
                        progressColor: Colors.blue,
                        lineHeight: 8,
                        width: 150,
                        barRadius: const Radius.circular(5),
                        trailing: Text('$totalCrisma - Crisma'),
                      ),
                      const SizedBox(height: 10),
                      LinearPercentIndicator(
                        animation: true,
                        percent: 1.0,
                        progressColor: Colors.yellow,
                        lineHeight: 8,
                        width: 150,
                        barRadius: const Radius.circular(5),
                        trailing: Text('$totalJovens - Jovens'),
                      ),
                      const SizedBox(height: 10),
                      LinearPercentIndicator(
                        animation: true,
                        percent: 1.0,
                        progressColor: Colors.indigo,
                        lineHeight: 8,
                        width: 150,
                        barRadius: const Radius.circular(5),
                        trailing: Text('$totalAdultos - Adultos'),
                      ),
                      const SizedBox(height: 10),
                      LinearPercentIndicator(
                        animation: true,
                        percent: 1.0,
                        progressColor: Colors.deepOrange,
                        lineHeight: 8,
                        width: 150,
                        barRadius: const Radius.circular(5),
                        trailing: Text('${snapshot.data?.length} - Total'),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$totalEucaristia', style: const TextStyle(color: Colors.green)),
                      Text('$totalCrisma', style: const TextStyle(color: Colors.blue)),
                      Text('$totalJovens', style: const TextStyle(color: Colors.yellow)),
                      Text('$totalAdultos', style: const TextStyle(color: Colors.indigo)),
                      Text('${snapshot.data?.length}', style: const TextStyle(color: Colors.deepOrange)),
                    ],
                  );
                }
              },
            ),
          );
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Página inicial'),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            footer: const Text('PCJ - Pastoral Catequetica'),
            items: items,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                RepostasPageView(),
                TurmasPageView(),
                CatequistasMainAdmin(),
                HorariosLocaisPageView(),
                Center(
                  child: Text('Avisos', style: TextStyle(color: Colors.black)),
                ),
                ConfigPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
