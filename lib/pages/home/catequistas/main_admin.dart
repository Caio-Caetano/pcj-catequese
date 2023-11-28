import 'package:flutter/material.dart';
import 'package:webapp/pages/home/catequistas/create_dialog.dart';
import 'package:webapp/pages/widgets/snackbar_custom.dart';

class CatequistasMainAdmin extends StatelessWidget {
  const CatequistasMainAdmin({super.key});

  @override
  Widget build(BuildContext context) {
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
                    return createDialog(
                      context: context,
                      submit: () {
                        Navigator.pop(context, true);
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
            )
          ],
        ),
      ],
    );
  }
}
