import 'package:flutter/material.dart';
import 'package:webapp/pages/admin/home/home_page.dart';

class HomePageRouteAdmin extends Page {
  final VoidCallback onLogout;
  const HomePageRouteAdmin({required this.onLogout}) : super(key: const ValueKey('HomePageAdmin'));

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