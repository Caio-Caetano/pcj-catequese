import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FormularioSucesso extends StatelessWidget {
  final VoidCallback onSubmit;
  final String response;
  const FormularioSucesso({super.key, required this.onSubmit, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Sucesso!'),
      ),
      body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset('./assets/lottie/sucesso_formulario.json'),
                  const SizedBox(height: 15),
                  const Text('A sua inscrição foi enviada com sucesso!', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Salve este número\n',
                      children: [
                        TextSpan(text: '| $response |', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
                        const TextSpan(text: '\nPoderá ser utilizado mais para frente.'),
                      ],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onSubmit,
        label: const Text('Início', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.home),
      ),
    );
  }
}

