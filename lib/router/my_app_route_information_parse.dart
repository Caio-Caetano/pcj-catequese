import 'package:flutter/material.dart';

import 'my_app_configuration.dart';

class MyAppRouteInformationParser extends RouteInformationParser<MyAppConfiguration> {
  @override
  Future<MyAppConfiguration> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    if (uri.pathSegments.isEmpty) {
      /// Se o que estiver após [ / ] for vazio será enviado para a home
      return MyAppConfiguration.home();
    } else if (uri.pathSegments.length == 1) {
      /// Recupera o primeira parametro escrita após a [ / ]
      final first = uri.pathSegments[0].toLowerCase();
      if (first == 'home') {
        return MyAppConfiguration.home();
      } else if (first == 'login') {
        return MyAppConfiguration.login();
      } else if (first == 'inscricao') {
        return MyAppConfiguration.register();
      } else {
        /// Retorna desconhecido 404 caso não encontre o parametro após [ / ]
        return MyAppConfiguration.unknown();
      }
    } else {
      /// Retorna desconhecido 404 caso de algum erro [ / ]
      return MyAppConfiguration.unknown();
    }
  }

  @override
  RouteInformation? restoreRouteInformation(MyAppConfiguration configuration) {
    if (configuration.isUnknown) {
      return RouteInformation(uri: Uri.parse('/unknown'));
    } else if (configuration.isSplashPage) {
      return null;
    } else if (configuration.isLoginPage) {
      return RouteInformation(uri: Uri.parse('/login'));
    } else if (configuration.isRegisterPage) {
      return RouteInformation(uri: Uri.parse('/inscricao'));
    } else if (configuration.isSucessoPage) {
      return RouteInformation(uri: Uri.parse('/sucesso'));
    } else if (configuration.isHomePage) {
      return RouteInformation(uri: Uri.parse('/'));
    } else {
      return null;
    }
  }
}