import 'package:flutter/material.dart';
import 'package:webapp/controller/config_controller.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    final ConfigController configController = ConfigController();
    return FutureBuilder(
      future: configController.getFormAberto(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Carregando...');
        }
        bool open = snapshot.data ?? false;
        return Column(
          children: [
            Row(
              children: [
                const Text('Formulário aberto:'),
                const Spacer(),
                Switch(
                  activeColor: Colors.green,
                  activeTrackColor: Colors.greenAccent,
                  inactiveThumbColor: Colors.blueGrey.shade600,
                  inactiveTrackColor: Colors.grey.shade400,
                  value: open,
                  onChanged: (value) async {
                    await configController.updateFormAberto();
                    setState(() {});
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
