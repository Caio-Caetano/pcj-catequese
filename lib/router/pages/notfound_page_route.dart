import 'package:flutter/material.dart';
import 'package:webapp/pages/404/page_notfound.dart';

class NotFoundPageRoute extends Page {

  const NotFoundPageRoute() : super(key: const ValueKey('NotFoundPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const PageNotFound();
      },
    );
  }
}