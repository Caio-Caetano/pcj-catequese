import 'package:flutter/material.dart';
import 'package:webapp/pages/widgets/card_resposta.dart';

Widget criarListaInscricoes(List<Map<String, dynamic>>? inscricoes, Function() setstate, int accessLevel) => inscricoes!.isEmpty
    ? const Text('Sem inscrições')
    : Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: inscricoes.length,
          itemBuilder: (context, index) {
            return cardResposta(inscricao: inscricoes[index], context: context, setstate: () => setstate(), accessLevel: accessLevel);
          },
        ),
      );
