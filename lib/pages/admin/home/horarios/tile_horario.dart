// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TileHorario extends StatelessWidget {
  const TileHorario({
    Key? key,
    required this.item,
    required this.onDelete,
  }) : super(key: key);

  final String item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          SizedBox(width: 300, child: Text(item, style: Theme.of(context).textTheme.labelSmall)),
          const Spacer(),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.close, color: Colors.red),
          )
        ],
      ),
    );
  }
}
