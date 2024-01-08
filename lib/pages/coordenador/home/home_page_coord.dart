import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:provider/provider.dart';
import 'package:webapp/pages/coordenador/dashboard_coordenacao_page.dart';
import 'package:webapp/pages/sidemenu/catequistas/main.dart';
import 'package:webapp/pages/sidemenu/respostas/main.dart';
import 'package:webapp/pages/sidemenu/turmas/main.dart';
import 'package:webapp/viewmodels/auth_view_model.dart';

class HomePageCoord extends StatefulWidget {
  const HomePageCoord({super.key, required this.onLogout, required this.etapa, required this.nomeCatequista});
  final VoidCallback onLogout;
  final String? nomeCatequista;
  final String? etapa;

  @override
  State<HomePageCoord> createState() => _HomePageCoordState();
}

class _HomePageCoordState extends State<HomePageCoord> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final controller = SideMenuController();
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Página inicial'),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: controller,
            hasResizer: false,
            hasResizerToggle: false,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            builder: (data) {
              return SideMenuData(
                header: data.isOpen
                    ? Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Icon(Icons.person),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(widget.nomeCatequista ?? 'Nome', style: Theme.of(context).textTheme.labelMedium),
                              Text(widget.etapa ?? 'Etapa', style: Theme.of(context).textTheme.labelSmall),
                            ],
                          )
                        ],
                      )
                    : const Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(Icons.person),
                      ),
                items: [
                  _buildTile(index: 0, title: 'Dashboard', icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard),
                  _buildTile(index: 1, title: 'Respostas', icon: Icons.article_outlined, selectedIcon: Icons.article),
                  _buildTile(index: 2, title: 'Turmas', icon: Icons.groups_outlined, selectedIcon: Icons.groups),
                  _buildTile(index: 3, title: 'Catequistas', icon: Icons.people_outlined, selectedIcon: Icons.people),
                ],
                footer: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: data.isOpen ? 10 : 5),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        await authViewModel.logout();
                        widget.onLogout();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout, size: 20, color: Colors.black),
                              SizedBox(width: data.isOpen ? 10 : 0),
                              data.isOpen
                                  ? const Text(
                                      'Sair',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          _buildPageView(_currentIndex),
        ],
      ),
    );
  }

  SideMenuItemDataTile _buildTile({required int index, required String title, required IconData icon, required IconData selectedIcon}) => SideMenuItemDataTile(
        isSelected: _currentIndex == index,
        onTap: () => setState(() => _currentIndex = index),
        title: title,
        hasSelectedLine: false,
        borderRadius: BorderRadius.circular(10),
        hoverColor: Colors.red[400],
        selectedTitleStyle: const TextStyle(fontWeight: FontWeight.w700),
        icon: Icon(icon),
        selectedIcon: Icon(selectedIcon),
        highlightSelectedColor: Colors.redAccent.withOpacity(0.4),
      );

  Widget _buildPageView(int index) {
    List<Widget> list = [
      DashboardCoordenacaoPage(etapa: widget.etapa),
      RepostasPageView(etapa: widget.etapa),
      TurmasPageView(etapa: widget.etapa),
      PageViewCatequistas(etapa: widget.etapa, isCoord: true),
    ];
    return Expanded(child: list[index]);
  }
}
