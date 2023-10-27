import 'package:flutter/material.dart';
import 'package:webapp/data/auth_repository.dart';
import 'package:webapp/enums.dart';
import 'package:webapp/router/my_app_configuration.dart';
import 'package:webapp/router/pages/form_batismo_page_route.dart';
import 'package:webapp/router/pages/form_contato_page.dart';
import 'package:webapp/router/pages/form_endereco_page_route.dart';
import 'package:webapp/router/pages/form_eucaristia_page_route.dart';
import 'package:webapp/router/pages/form_local_page_route.dart';
import 'package:webapp/router/pages/form_nome_page_route.dart';
import 'package:webapp/router/pages/form_sucesso_page_route.dart';
import 'package:webapp/router/pages/home_page_route.dart';
import 'package:webapp/router/pages/login_page_route.dart';
import 'package:webapp/router/pages/notfound_page_route.dart';
import 'package:webapp/router/pages/register_page_route.dart';
import 'package:webapp/router/pages/splash_screen_route.dart';

class MyAppRouterDelegate extends RouterDelegate<MyAppConfiguration> with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyAppConfiguration> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final AuthRepository authRepository;

  bool? _show404;
  bool? get show404 => _show404;
  set show404(bool? value) {
    _show404 = value;
    if (value == true) {}
    notifyListeners();
  }

  bool? _loggedIn;
  bool? get loggedIn => _loggedIn;
  set loggedIn(value) {
    if (_loggedIn == true && value == false) {
      // It is a logout!
      _clear();
    }
    _loggedIn = value;
    notifyListeners();
  }

  bool? _registerPage;
  bool? get registerPage => _registerPage;
  set registerPage(value) {
    if (_registerPage == true && value == false) {
      _clear();
    }
    _registerPage = value;
    notifyListeners();
  }

  bool? _sucessoPage;
  bool? get sucessoPage => _sucessoPage;
  set sucessoPage(value) {
    if (_sucessoPage == true && value == false) {
      _clear();
    }
    _sucessoPage = value;
    notifyListeners();
  }

  Turma? _formNomes;
  Turma? get formNomes => _formNomes;
  set formNomes(Turma? value) {
    _formNomes = value;
    notifyListeners();
  }

  bool? _formEndereco;
  bool? get formEndereco => _formEndereco;
  set formEndereco(value) {
    _formEndereco = value;
    notifyListeners();
  }

  bool? _formContato;
  bool? get formContato => _formContato;
  set formContato(value) {
    _formContato = value;
    notifyListeners();
  }

  bool? _formBatismo;
  bool? get formBatismo => _formBatismo;
  set formBatismo(value) {
    _formBatismo = value;
    notifyListeners();
  }

  bool? _formEucaristia;
  bool? get formEucaristia => _formEucaristia;
  set formEucaristia(value) {
    _formEucaristia = value;
    notifyListeners();
  }

  bool? _formLocal;
  bool? get formLocal => _formLocal;
  set formLocal(value) {
    _formLocal = value;
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  MyAppRouterDelegate(this.authRepository) {
    _init();
  }

  _init() async {
    loggedIn = await authRepository.isUserLoggedIn();
  }

  @override
  MyAppConfiguration? get currentConfiguration {
    if (registerPage == true) {
      return MyAppConfiguration.register();
    } else if (loggedIn == false) {
      return MyAppConfiguration.login();
    } else if (loggedIn == null) {
      return MyAppConfiguration.splash();
    } else if (show404 == true) {
      return MyAppConfiguration.unknown();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Page> stack;
    final loggedIn = this.loggedIn;
    if (show404 == true) {
      stack = _unknownStack;
    } else if (loggedIn == null) {
      stack = _splashStack;
    } else if (loggedIn) {
      stack = _loggedInStack;
    } else if (registerPage != null) {
      stack = _registerStack;
    } else if (sucessoPage == true) {
      stack = _sucessoStack;
    } else {
      stack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: stack,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        return true;
      },
    );
  }

  List<Page> get _splashStack {
    String? process;
    if (loggedIn == null) {
      process = 'Verificando o login...';
    } else {
      process = "Processo indefinido...";
    }
    return [
      SplashPageRoute(process: process),
    ];
  }

  List<Page> get _unknownStack => [const NotFoundPageRoute()];

  List<Page> get _sucessoStack => [
        FormSucessoPageRoute(onSubmit: () {
          _clear();
        })
      ];

  List<Page> get _registerStack {
    final formNomes = this.formNomes;
    final formEndereco = this.formEndereco;
    final formContato = this.formContato;
    final formBatismo = this.formBatismo;
    final formEucaristia = this.formEucaristia;
    final formLocal = this.formLocal;

    String etapa = _extractTextFromTurma(formNomes ?? Turma.erro);

    Function() onSubmitBatismoEucaristia(String etapa) {
      if (etapa.contains('Eucaristia')) {
        return () => this.formLocal = true;
      } else {
        return () => this.formEucaristia = true;
      }
    }

    return [
      RegisterPageRoute((Turma? turma) => this.formNomes = turma, () => _clear()),
      if (formNomes != null) FormNomesPageRoute(etapa: etapa, onSubmit: () => this.formEndereco = true),
      if (formNomes != null && formEndereco == true) FormEnderecoPageRoute(etapa: etapa, onSubmit: () => this.formContato = true),
      if (formNomes != null && formContato == true) FormContatoPageRoute(etapa: etapa, onSubmit: () => this.formBatismo = true),
      if (formNomes != null && formBatismo == true) FormBatismoPageRoute(etapa: etapa, onSubmit: onSubmitBatismoEucaristia(etapa)),
      if (formNomes != null && formEucaristia == true) FormEucaristiaPageRoute(etapa: etapa, onSubmit: () => this.formLocal = true),
      if (formNomes != null && formLocal == true)
        FormLocalPageRoute(
          etapa: etapa,
          onSubmit: () {
            _clear();
            sucessoPage = true;
          },
        ),
    ];
  }

  List<Page> get _loggedOutStack => [
        LoginPageRoute(onRegisterClick: () => registerPage = true),
      ];

  List<Page> get _loggedInStack {
    return [
      const HomePageRoute(),
    ];
  }

  @override
  Future<void> setNewRoutePath(MyAppConfiguration configuration) async {
    if (configuration.unknown) {
      show404 = true;
      sucessoPage = null;
      formNomes = null;
      formEndereco = null;
      formContato = null;
      formBatismo = null;
      formEucaristia = null;
      formLocal = null;
    } else if (configuration.isHomePage || configuration.isLoginPage || configuration.isSplashPage) {
      show404 = false;
      registerPage = null;
      sucessoPage = null;
      formNomes = null;
      formEndereco = null;
      formContato = null;
      formBatismo = null;
      formEucaristia = null;
      formLocal = null;
    } else if (configuration.isRegisterPage) {
      show404 = false;
      registerPage = true;
      sucessoPage = null;
      formNomes = null;
      formEndereco = null;
      formContato = null;
      formBatismo = null;
      formEucaristia = null;
      formLocal = null;
    } else if (configuration.isSucessoPage) {
      show404 = false;
      registerPage = null;
      sucessoPage = true;
      formNomes = null;
      formEndereco = null;
      formContato = null;
      formBatismo = null;
      formEucaristia = null;
      formLocal = null;
    } else {
      print('Could not set new route');
    }
  }

  _clear() {
    show404 = null;
    sucessoPage = null;
    registerPage = null;
    formNomes = null;
    formEndereco = null;
    formContato = null;
    formBatismo = null;
    formEucaristia = null;
    formLocal = null;
  }
}

String _extractTextFromTurma(Turma turma) {
  switch (turma) {
    case Turma.eucaristia1:
      return '1º Etapa - Eucaristia';
    case Turma.eucaristia2:
      return '2º Etapa - Eucaristia';
    case Turma.eucaristia3:
      return '3º Etapa - Eucaristia';
    case Turma.crisma1:
      return '1º Etapa - Crisma';
    case Turma.crisma2:
      return '2º Etapa - Crisma';
    case Turma.crisma3:
      return '3º Etapa - Crisma';
    case Turma.jovens:
      return 'Jovens';
    case Turma.adultos:
      return 'Adultos';
    default:
      return 'Erro';
  }
}
