import 'package:flutter/material.dart';

class CardSectionWidget extends StatelessWidget {
  final Widget content;
  final String title;
  const CardSectionWidget({super.key, required this.content, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: const Color.fromARGB(255, 255, 237, 237),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Center(child: Text(title, style: Theme.of(context).textTheme.titleMedium)), content],
        ),
      ),
    );
  }
}
