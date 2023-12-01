import 'package:flutter/material.dart';
import 'package:webapp/pages/admin/home/home_page.dart';

class HomePageRouteCatequista extends Page {
  final VoidCallback onLogout;
  const HomePageRouteCatequista({required this.onLogout}) : super(key: const ValueKey('HomePageCatequista'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return HomePage(onLogout: onLogout);
      },
    );
  }
}