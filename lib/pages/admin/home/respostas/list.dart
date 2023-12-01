import 'package:flutter/material.dart';
import 'package:webapp/pages/widgets/card_resposta.dart';

Widget criarListaInscricoes(List<Map<String, dynamic>>? inscricoes, Function() setstate, int accessLevel) => Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: inscricoes!.length,
        itemBuilder: (context, index) {
          return cardResposta(etapa: inscricoes[index], context: context, setstate: () => setstate(), accessLevel: accessLevel);
        },
      ),
    );
