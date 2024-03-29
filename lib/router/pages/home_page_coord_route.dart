import 'package:flutter/material.dart';
import 'package:webapp/pages/coordenador/home/home_page_coord.dart';

class HomePageRouteCoord extends Page {
  final VoidCallback onLogout;
  final String? etapa;
  final String? nomeCatequista;
  const HomePageRouteCoord({required this.onLogout, required this.etapa, required this.nomeCatequista,}) : super(key: const ValueKey('HomePageCoord'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return HomePageCoord(onLogout: onLogout, etapa: etapa, nomeCatequista: nomeCatequista);
      },
    );
  }
}