import 'package:flutter/material.dart';

class BadgeFiltro extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final void Function(String) onChange;
  final String? hintText;
  const BadgeFiltro({super.key, required this.items, required this.onChange, this.selectedItem, this.hintText});

  @override
  State<BadgeFiltro> createState() => _BadgeFiltroState();
}

class _BadgeFiltroState extends State<BadgeFiltro> {

  late List<String> options = ['Todos'];
  late String selectedItem;
  
  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem == null ? options.first : widget.selectedItem!;
  }

  @override
  Widget build(BuildContext context) {
    options.clear();
    options.addAll(widget.items);

    return DropdownMenu<String>(
      initialSelection: selectedItem,
      hintText: widget.hintText,
      label: Text(widget.hintText ?? ''),
      onSelected: (value) {
        widget.onChange(value!);
        setState(() {
          selectedItem = value;
        });
      },
      dropdownMenuEntries: options.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(), 
    );
  }
}