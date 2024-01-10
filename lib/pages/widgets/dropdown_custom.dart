import 'package:flutter/material.dart';

class DropdownButtonCustom extends StatefulWidget {
  const DropdownButtonCustom({
    super.key,
    this.onChanged,
    this.hintText = 'Selecione...',
    this.value,
    this.items,
    this.label,
    this.validator,
  });

  final Function(String?)? onChanged;
  final String? hintText;
  final String? value;
  final List<DropdownMenuItem<String>>? items;
  final String? label;
  final String? Function(String?)? validator;

  @override
  State<DropdownButtonCustom> createState() => _DropdownButtonCustomState();
}

class _DropdownButtonCustomState extends State<DropdownButtonCustom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) Text(widget.label!),
        DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: widget.hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          borderRadius: BorderRadius.circular(20),
          dropdownColor: Colors.grey[400],
          value: widget.value,
          onChanged: widget.onChanged,
          items: widget.items,
          validator: widget.validator,
        ),
      ],
    );
  }
}
