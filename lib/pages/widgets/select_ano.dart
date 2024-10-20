import 'package:flutter/material.dart';

const List<Map<String, String>> anos = [{'2024': 'inscricoes'}, {'2025': 'inscricoes2025'}];

class SelectAno extends StatefulWidget {
  final void Function(String) onChange;
  const SelectAno({super.key, required this.onChange});

  @override
  State<SelectAno> createState() => _SelectAnoState();
}

class _SelectAnoState extends State<SelectAno> {
  Map<String, String> selectedAno = anos[1];

  @override
  Widget build(BuildContext context) {
    return  DropdownMenu<Map<String, String>>(
      initialSelection: anos[1],
      onSelected: (Map<String, String>? value) {
        widget.onChange(value!.values.first);
        // This is called when the user selects an item.
        setState(() {
          selectedAno = value;
        });
      },
      dropdownMenuEntries: anos.map<DropdownMenuEntry<Map<String, String>>>((Map<String, String> value) {
        return DropdownMenuEntry<Map<String, String>>(value: value, label: value.keys.first);
      }).toList(),
    );
  }
}