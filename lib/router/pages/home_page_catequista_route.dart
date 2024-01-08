import 'package:flutter/material.dart';
import 'package:webapp/pages/catequista/home/home_page_cate.dart';

class HomePageRouteCatequista extends Page {
  final VoidCallback onLogout;
  final String? etapa;
  final String? catequista;
  const HomePageRouteCatequista({required this.onLogout, required this.etapa, required this.catequista}) : super(key: const ValueKey('HomePageCatequista'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return HomePageCatequista(onLogout: onLogout, etapa: etapa, nomeCatequista: catequista);
      },
    );
  }
}