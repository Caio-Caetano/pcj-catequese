import 'package:flutter/material.dart';
import 'package:webapp/pages/admin/home/horarios/expansion_catequese.dart';

class HorariosLocaisPageView extends StatelessWidget {
  const HorariosLocaisPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ExpansionTile(
          title: Text('1º Eucaristia'),
          children: [ExpansionLocais(etapa: 'eucaristia')],
        ),
        ExpansionTile(
          title: Text('Crisma'),
          children: [ExpansionLocais(etapa: 'crisma')],
        ),
        ExpansionTile(
          title: Text('Jovens'),
          children: [ExpansionLocais(etapa: 'jovens')],
        ),
        ExpansionTile(
          title: Text('Adultos'),
          children: [ExpansionLocais(etapa: 'adultos')],
        ),
      ],
    );
  }
}
