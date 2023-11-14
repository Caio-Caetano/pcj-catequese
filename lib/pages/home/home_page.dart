import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/pages/home/respostas/main.dart';
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
        title: 'Etapas',
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
        title: 'Sair',
        onTap: (_, __) async {
          await authViewModel.logout();
          widget.onLogout();
        },
        icon: const Icon(Icons.logout),
      ),
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
            footer: const Text('demo'),
            items: items,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                RepostasPageView(),
                Center(
                  child: Text('Settings', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
