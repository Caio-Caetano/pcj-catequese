import 'package:flutter/material.dart';
import 'package:webapp/controller/user_controller.dart';
import 'package:webapp/data/user_repository.dart';
import 'package:webapp/pages/admin/home/catequistas/create_dialog.dart';
import 'package:webapp/pages/admin/home/catequistas/delete_dialog.dart';
import 'package:webapp/pages/admin/home/catequistas/edit_dialog.dart';
import 'package:webapp/pages/widgets/card_usuario.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';

class CatequistasCoord extends StatefulWidget {
  const CatequistasCoord({super.key, this.etapa});
  final String? etapa;

  @override
  State<CatequistasCoord> createState() => _CatequistasCoordState();
}

class _CatequistasCoordState extends State<CatequistasCoord> {
  @override
  Widget build(BuildContext context) {
    final userController = UserController(UserRepository());
    List<Map<String, dynamic>> usuarios = [];
    return Column(
      children: [
        Wrap(
          direction: Axis.vertical,
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Lista de catequistas', style: Theme.of(context).textTheme.titleLarge),
            ElevatedButton(
              onPressed: () async {
                bool result = await showDialog(
                  context: context,
                  builder: (context) {
                    return DialogCreateCatequista(
                      contextAlt: context,
                      isCoord: true,
                      etapaCoord: widget.etapa,
                      submit: () {
                        Navigator.pop(context, true);
                        setState(() {});
                      },
                      back: () {
                        Navigator.pop(context, false);
                      },
                    );
                  },
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                result ? ScaffoldMessenger.of(context).showSnackBar(createSnackBar('😁 Catequista criado com sucesso!')) : ScaffoldMessenger.of(context).showSnackBar(createSnackBar('❌ Sem sucesso!'));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Criar novo', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  Icon(Icons.add),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
              future: userController.getUsuarios(etapa: widget.etapa),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('Carregando...'));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar!\n${snapshot.error}'));
                }

                usuarios = snapshot.data ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () => showDialog(
                          context: context,
                          builder: (context) => UserDeleteDialog(
                              id: usuarios[index]['id'],
                              back: () {
                                Navigator.pop(context);
                                setState(() {});
                              })),
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) => UserEditDialog(
                              isCoord: true,
                              map: usuarios[index],
                              back: () {
                                Navigator.pop(context);
                                setState(() {});
                              })),
                      child: cardUsuario(usuario: usuarios[index]),
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}
