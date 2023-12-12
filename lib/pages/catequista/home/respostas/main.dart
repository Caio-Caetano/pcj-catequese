import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RespostasPageViewCatequista extends StatelessWidget {
  const RespostasPageViewCatequista({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            './assets/lottie/construction.json',
            width: 200,
          ),
          const Text('Em construção...')
        ],
      ),
    );
  }
}
