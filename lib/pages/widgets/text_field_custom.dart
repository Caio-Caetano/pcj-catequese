import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom({
    super.key,
    required this.controller,
    this.formatter,
    this.validator,
    this.labelText,
    this.iconPrefix,
    this.hintText, 
    this.onChanged,
    this.readOnly = false
  });

  final TextEditingController controller;
  final List<MaskTextInputFormatter>? formatter;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  final String? labelText;
  final Icon? iconPrefix;
  final String? hintText;

  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(labelText ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
        TextFormField(
          controller: controller,
          inputFormatters: formatter,
          validator: validator,
          onChanged: onChanged,
          readOnly: readOnly,
          decoration: InputDecoration(
            prefixIcon: iconPrefix,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(15)),
            errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(15)),
            focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(15)),
            errorStyle: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
    );
  }
}
