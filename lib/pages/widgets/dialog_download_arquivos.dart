import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:webapp/functions/open_link.dart';

Widget dialogDownloadArquivos(Map<String, dynamic> dados, VoidCallback voltar, BuildContext context) {
  return AlertDialog(
    title: const Text('Documentos enviados.'),
    content: SingleChildScrollView(
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          if (dados['batismo'] != null)
            if (dados['batismo']['possui'])
              ElevatedButton(onPressed: () async {
                if (dados['batismo']['arquivo'] != null && dados['batismo']['arquivo'] != '') {
                  await launch(dados['batismo']['arquivo'], isNewTab: false);
                } else {
                  toastification.show(
                    context: context,
                    title: const Text('Erro'),
                    description: const Text('Arquivo do batismo não foi adicionado.'),
                    style: ToastificationStyle.minimal,
                    type: ToastificationType.error,
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 10)
                  );
                }
              }, child: const Text('Batismo')),
          if (dados['eucaristia'] != null)
            if (dados['eucaristia']['possui'])
              ElevatedButton(onPressed: () async {
                if (dados['eucaristia']['arquivo'] != null || dados['eucaristia']['arquivo'] != '') {
                  await launch(dados['eucaristia']['arquivo'], isNewTab: false);
                } else {
                  toastification.show(
                    context: context,
                    title: const Text('Erro.'),
                    description: const Text('Arquivo da 1ª Eucaristia não foi adicionado.'),
                    style: ToastificationStyle.minimal,
                    type: ToastificationType.error,
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 10)
                  );
                }
              }, child: const Text('1º Eucaristia')),
        ],
      ),
    ),
  );
}