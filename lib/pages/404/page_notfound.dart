import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('404 - Não encontrado', style: Theme.of(context).textTheme.titleLarge)
    );
  }
}