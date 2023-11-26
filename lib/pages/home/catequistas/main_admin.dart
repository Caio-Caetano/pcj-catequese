import 'package:flutter/material.dart';

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
              onPressed: () {},
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
