import 'package:flutter/material.dart';
import 'package:webapp/pages/splash/splash_page.dart';

class SplashPageRoute extends Page {
  final String process;

  SplashPageRoute({required this.process}) : super(key: ValueKey('SplashPage$process'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return SplashScreen(process: process);
      },
    );
  }
}