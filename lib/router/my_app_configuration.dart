class MyAppConfiguration {
  final bool unknown;
  final bool? loggedIn;
  final bool? register;
  final bool? sucesso;

  MyAppConfiguration.splash()
      : unknown = false,
        loggedIn = null,
        register = null,
        sucesso = null;

  MyAppConfiguration.login()
      : unknown = false,
        loggedIn = false,
        register = false,
        sucesso = false;

  MyAppConfiguration.register()
      : unknown = false,
        loggedIn = false,
        register = true,
        sucesso = false;

  MyAppConfiguration.home()
      : unknown = false,
        loggedIn = true,
        register = false,
        sucesso = false;

  MyAppConfiguration.unknown()
      : unknown = true,
        loggedIn = null,
        register = null,
        sucesso = null;

  bool get isUnknown => unknown == true;
  bool get isHomePage => unknown == false && loggedIn == true && register == false;
  bool get isLoginPage => unknown == false && loggedIn == false && register == false;
  bool get isSplashPage => unknown == false && loggedIn == null && register == null;
  bool get isRegisterPage => unknown == false && register == true && loggedIn == false;
  bool get isSucessoPage => unknown == false && sucesso == true && loggedIn == false;
}