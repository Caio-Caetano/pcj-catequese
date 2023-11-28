import 'package:flutter/material.dart';
import 'package:webapp/pages/home/respostas/card.dart';

Widget criarListaInscricoes(List<Map<String, dynamic>>? inscricoes, Function() setstate) => Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: inscricoes!.length,
        itemBuilder: (context, index) {
          return cardResposta(etapa: inscricoes[index], context: context, setstate: () => setstate());
        },
      ),
    );
