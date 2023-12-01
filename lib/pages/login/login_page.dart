import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:webapp/controller/config_controller.dart';
import 'package:webapp/pages/login/popup_login.dart';


class LoginPage extends StatelessWidget {
  final Function(int) onLogin;
  final VoidCallback onRegisterClick;
  const LoginPage({super.key, required this.onRegisterClick, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final ConfigController configController = ConfigController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Pastoral catequetica - PCJ', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                showDialog(context: context, builder: (context) => PopUpLogin(onLogin: onLogin));
              },
              borderRadius: BorderRadius.circular(15),
              child: Ink(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: const BorderRadius.all(Radius.circular(15))),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Login', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 5),
                    const Icon(Icons.login, color: Colors.white),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: configController.getFormAberto(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              bool open = snapshot.data ?? false;
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 250,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Aviso!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        open ? const Text('O formulário está aberto e com vagas limitadas.') : const Text('O formulário para inscrição será liberado a partir do dia 01/12, e com vagas limitadas.'),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (open)
                    Center(
                      child: ElevatedButton(
                        onPressed: onRegisterClick,
                        child: const Text('Inscrição', style: TextStyle(fontSize: 24)),
                      ),
                    )
                  else
                    const Text('Inscrição Fechadas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Spacer(),
                ],
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        tooltip: 'Links',
        label: const Text('Links', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        children: [
          SpeedDialChild(child: const Icon(Icons.photo_camera, color: Colors.white), label: 'Instagram', backgroundColor: Colors.pink),
          SpeedDialChild(child: const Icon(Icons.book, color: Colors.white), label: 'Facebook', backgroundColor: Colors.blue),
          SpeedDialChild(child: const Icon(Icons.language, color: Colors.white), label: 'Website', backgroundColor: Colors.indigo),
        ],
      ),
    );
  }
}
