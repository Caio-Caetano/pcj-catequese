import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  final String? process;

  const SplashScreen({Key? key, this.process}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            LottieBuilder.asset('./assets/lottie/loading.json'),
            const SizedBox(height: 15),
            Text(process ?? '', style: Theme.of(context).textTheme.titleLarge),
          ],
        ))
    );
  }
}