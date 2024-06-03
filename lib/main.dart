import 'package:common/cache/preference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/configureweb.dart';
import 'package:webapp/data/auth_repository.dart';
import 'package:webapp/firebase_options.dart';
import 'package:webapp/providers/loading_notifier.dart';
import 'package:webapp/router/my_app_delegate.dart';
import 'package:webapp/router/my_app_route_information_parse.dart';
import 'package:webapp/styles/dark_theme.dart';
import 'package:webapp/styles/light_theme.dart';
import 'package:webapp/viewmodels/auth_view_model.dart';
import 'package:webapp/viewmodels/inscricao_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyAppRouterDelegate delegate;
  late MyAppRouteInformationParser parser;
  late AuthRepository authRepository;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository(Preference());
    delegate = MyAppRouterDelegate(authRepository);
    parser = MyAppRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel(authRepository)),
        ChangeNotifierProvider<InscricaoProvider>(create: (_) => InscricaoProvider()),
        ChangeNotifierProvider<LoadingClass>(create: (_) => LoadingClass()),
      ],
      child: MaterialApp.router(
        title: 'Catequese PCJ',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        routerDelegate: delegate,
        routeInformationParser: parser,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
