import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:webapp/controller/config_controller.dart';
import 'package:webapp/functions/open_link.dart';
import 'package:webapp/pages/login/popup_login.dart';
import 'package:webapp/pages/widgets/appbar_custom.dart';
import 'package:webapp/pages/widgets/container_shadow_custom.dart';

class LoginPage extends StatelessWidget {
  final Function(int, String?, String?) onLogin;
  final VoidCallback onRegisterClick;
  const LoginPage({super.key, required this.onRegisterClick, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final ConfigController configController = ConfigController();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFDECEC),
            Color(0xFFFCE3E3),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarCustom('Pastoral Catequetica - PCJ'),
        body: Center(
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: configController.getFormAberto(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  bool open = snapshot.data!['formOpen'] ?? false;
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      spacing: 40.0,
                      runSpacing: 30.0,
                      children: [
                        InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                          onTap: open ? onRegisterClick : () {},
                          mouseCursor: open ? SystemMouseCursors.click : SystemMouseCursors.basic,
                          child: ContainerShadowCustom(
                            height: 500,
                            width: 350,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(open ? './assets/images/sent.png' : './assets/images/closed.png'),
                                if (open)
                                  const Text('Nova inscrição', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF570808), fontSize: 36))
                                else
                                  const Text('Inscrições fechadas', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF570808), fontSize: 36), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ).animate().moveX(duration: 400.milliseconds, delay: 100.milliseconds).fade(duration: 300.milliseconds),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ContainerShadowCustom(
                              height: 320,
                              width: 350,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const Text('Aviso', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF570808), fontSize: 36)),
                                    Expanded(child: Text('${snapshot.data!['avisoFechado']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24))),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 40.0,
                                runSpacing: 30.0,
                                children: [
                                  InkWell(
                                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                    onTap: () async {
                                      await launch('https://www.instagram.com/coracaodejesussjc/', isNewTab: false);
                                    },
                                    child: ContainerShadowCustom(
                                      height: 140,
                                      width: 155,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('./assets/icons/website.png', height: 80, width: 80),
                                          const Text('Instagram', style: TextStyle(color: Color(0xFF570808), fontSize: 20, fontWeight: FontWeight.w300)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                    onTap: () {
                                      configureModalBottomSheet(context, onLogin);
                                    },
                                    child: ContainerShadowCustom(
                                      height: 140,
                                      width: 155,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('./assets/icons/login.png', height: 80, width: 80),
                                          const Text('Catequista?', style: TextStyle(color: Color(0xFF570808), fontSize: 20, fontWeight: FontWeight.w300)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ).animate().moveX(duration: 400.milliseconds, delay: 500.milliseconds).fade()
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
