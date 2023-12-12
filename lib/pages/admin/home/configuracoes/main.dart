import 'package:flutter/material.dart';
import 'package:webapp/controller/config_controller.dart';
import 'package:webapp/pages/admin/home/configuracoes/popup_mensagem.dart';

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
        bool openGeral = snapshot.data!['formOpen'] ?? false;
        bool openEucaristia = snapshot.data!['eucaristia'] ?? false;
        bool openCrisma = snapshot.data!['crisma'] ?? false;
        bool openJovem = snapshot.data!['jovens'] ?? false;
        bool openAdulto = snapshot.data!['adultos'] ?? false;
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
                  value: openGeral,
                  onChanged: (value) async {
                    await configController.updateFormAberto();
                    setState(() {});
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Inscrições para Eucaristia:'),
                const Spacer(),
                Switch(
                  activeColor: Colors.green,
                  activeTrackColor: Colors.greenAccent,
                  inactiveThumbColor: Colors.blueGrey.shade600,
                  inactiveTrackColor: Colors.grey.shade400,
                  value: openEucaristia,
                  onChanged: (value) async {
                    await configController.updateFormEspecifico('eucaristia');
                    setState(() {});
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Inscrições para Crisma:'),
                const Spacer(),
                Switch(
                  activeColor: Colors.green,
                  activeTrackColor: Colors.greenAccent,
                  inactiveThumbColor: Colors.blueGrey.shade600,
                  inactiveTrackColor: Colors.grey.shade400,
                  value: openCrisma,
                  onChanged: (value) async {
                    await configController.updateFormEspecifico('crisma');
                    setState(() {});
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Inscrições para Jovem:'),
                const Spacer(),
                Switch(
                  activeColor: Colors.green,
                  activeTrackColor: Colors.greenAccent,
                  inactiveThumbColor: Colors.blueGrey.shade600,
                  inactiveTrackColor: Colors.grey.shade400,
                  value: openJovem,
                  onChanged: (value) async {
                    await configController.updateFormEspecifico('jovens');
                    setState(() {});
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Inscrições para Adulto:'),
                const Spacer(),
                Switch(
                  activeColor: Colors.green,
                  activeTrackColor: Colors.greenAccent,
                  inactiveThumbColor: Colors.blueGrey.shade600,
                  inactiveTrackColor: Colors.grey.shade400,
                  value: openAdulto,
                  onChanged: (value) async {
                    await configController.updateFormEspecifico('adultos');
                    setState(() {});
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Mensagem de formulário fechado:'),
                const Spacer(),
                ElevatedButton(onPressed: () => showDialog(context: context, builder: (context) => const PopUpMensagemFechado()), child: const Text('Editar')),
              ],
            ),
          ],
        );
      },
    );
  }
}
