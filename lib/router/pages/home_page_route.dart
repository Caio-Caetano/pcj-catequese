import 'package:flutter/material.dart';
import 'package:webapp/pages/home/home_page.dart';

class HomePageRoute extends Page {

  const HomePageRoute() : super(key: const ValueKey('HomePage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const HomePage();
      },
    );
  }
}