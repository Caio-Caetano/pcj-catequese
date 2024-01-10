// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:provider/provider.dart';
import 'package:webapp/pages/catequista/home/turmas/main.dart';

import 'package:webapp/viewmodels/auth_view_model.dart';

class HomePageCatequista extends StatefulWidget {
  const HomePageCatequista({
    Key? key,
    required this.onLogout,
    required this.etapa,
    required this.nomeCatequista,
  }) : super(key: key);
  final VoidCallback onLogout;
  final String? etapa;
  final String? nomeCatequista;

  @override
  State<HomePageCatequista> createState() => _HomePageCatequistaState();
}

class _HomePageCatequistaState extends State<HomePageCatequista> {

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
                  _buildTile(index: 0, title: 'Suas turmas', icon: Icons.groups_outlined, selectedIcon: Icons.groups),
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
      TurmasCatequista(nomeCatequista: widget.nomeCatequista),
    ];
    return Expanded(child: list[index]);
  }
}
