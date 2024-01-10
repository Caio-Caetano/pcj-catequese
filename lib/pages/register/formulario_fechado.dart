import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FormularioFechado extends StatelessWidget {
  final VoidCallback onSubmit;
  final String etapa;
  const FormularioFechado({super.key, required this.onSubmit, required this.etapa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Formulário Fechado!'),
      ),
      body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset('./assets/lottie/form_fechado.json'),
                  const SizedBox(height: 15),
                  Text('A inscrição para a etapa de $etapa está atualmente fechada. Limite de vagas atingidas.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Caso tenha alguma dúvida, entre em contato com a secretaria', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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

