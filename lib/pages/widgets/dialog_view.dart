import 'package:flutter/material.dart';
import 'package:webapp/functions/open_link.dart';

Widget viewDialog(Map<String, dynamic> inscricao, VoidCallback back, BuildContext context) {
  return AlertDialog(
    title: const Text('Inscrição'),
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nome: ${inscricao['nome']}'),
          Text('Nome da Mãe: ${inscricao['nomeMae']}', style: Theme.of(context).textTheme.labelLarge),
          Text('Nome do Pai: ${inscricao['nomePai']}', style: Theme.of(context).textTheme.labelLarge),
          Text('Nome do Responsável: ${inscricao['nomeResponsavel']}', style: Theme.of(context).textTheme.labelLarge),
          const Divider(),
          Text('Telefone: ${inscricao['telefone'].substring(0, 2)} ${inscricao['telefone'].substring(2)}', style: Theme.of(context).textTheme.labelLarge),
          Text('E-mail: ${inscricao['email']}', style: Theme.of(context).textTheme.labelLarge),
          Text('Data de nascimento: ${inscricao['dataNascimento']}', style: Theme.of(context).textTheme.labelLarge),
          const Divider(),
          Text('Rua: ${inscricao['endereco']['rua']}', style: Theme.of(context).textTheme.labelLarge),
          Text('Número: ${inscricao['endereco']['numero']} - ${inscricao['endereco']['complemento']}', style: Theme.of(context).textTheme.labelLarge),
          Text('Bairro: ${inscricao['endereco']['bairro']}', style: Theme.of(context).textTheme.labelLarge),
          Text('CEP: ${inscricao['endereco']['cep']}', style: Theme.of(context).textTheme.labelLarge),
          if (inscricao['batismo'] != null || inscricao['eucaristia'] != null) const Divider(),
          if (inscricao['batismo'] != null && inscricao['batismo']['arquivo'] != null)
            GestureDetector(onTap: () => launch(inscricao['batismo']['arquivo'], isNewTab: true), child: Text('Visualizar batistério - Clique para baixar', style: Theme.of(context).textTheme.labelLarge))
          else
            Text('Não possui batismo', style: Theme.of(context).textTheme.labelLarge),
          if (inscricao['eucaristia'] != null && inscricao['eucaristia']['arquivo'] != null)
            GestureDetector(onTap: () => launch(inscricao['eucaristia']['arquivo'], isNewTab: true), child: Text('Visualizar lembraça 1º Eucaristia - Clique para baixar', style: Theme.of(context).textTheme.labelLarge))
          else
            Text('Não possui 1º eucaristia', style: Theme.of(context).textTheme.labelLarge),
          const Divider(),
          Text('Etapa: ${inscricao['etapa']}', style: Theme.of(context).textTheme.labelLarge),
          Text('Catequista: ', style: Theme.of(context).textTheme.labelLarge),
          const Divider(),
          Text('Identificador: ${inscricao['id']}', style: Theme.of(context).textTheme.labelMedium)
        ],
      ),
    ),
    actions: [
      ElevatedButton(onPressed: () => back(), child: const Text('Fechar')),
    ],
  );
}
