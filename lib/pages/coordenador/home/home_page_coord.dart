import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/pages/coordenador/home/catequistas/main.dart';
import 'package:webapp/pages/coordenador/home/respostas/main.dart';
import 'package:webapp/viewmodels/auth_view_model.dart';

class HomePageCoord extends StatefulWidget {
  const HomePageCoord({super.key, required this.onLogout, required this.etapa});
  final VoidCallback onLogout;
  final String? etapa;

  @override
  State<HomePageCoord> createState() => _HomePageCoordState();
}

class _HomePageCoordState extends State<HomePageCoord> {
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
        title: 'Catequistas',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.people),
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
          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: FutureBuilder(
              future: controllerRespostas.getRespostas(etapa: widget.etapa),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('Carregando...'));
                }

                if (displayMode == SideMenuDisplayMode.open) {
                  return Center(
                    child: CircularPercentIndicator(
                      animation: true,
                      radius: 60.0,
                      lineWidth: 5.0,
                      percent: 1.0,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Inscrições'),
                          Text('${snapshot.data?.length}'),
                        ],
                      ),
                      progressColor: Colors.green,
                    ),
                  );
                } else {
                  return Center(child: Text('${snapshot.data?.length}'));
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
              children: [
                RepostasPageViewCoord(etapa: widget.etapa),
                CatequistasCoord(etapa: widget.etapa),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
