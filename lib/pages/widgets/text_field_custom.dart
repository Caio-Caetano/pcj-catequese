import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextFieldCustom extends StatefulWidget {
  const TextFieldCustom({
    super.key,
    required this.controller,
    this.formatter,
    this.validator,
    this.labelText,
    this.iconPrefix,
    this.hintText,
    this.onChanged,
    this.readOnly = false,
    this.labelColor,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final List<MaskTextInputFormatter>? formatter;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  final String? labelText;
  final Icon? iconPrefix;
  final String? hintText;

  final bool readOnly;
  final bool? isPassword;

  final Color? labelColor;

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  bool isObscure = false;

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
              child: Text(widget.labelText ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: widget.labelColor)),
            ),
          ],
        ),
        TextFormField(
          controller: widget.controller,
          inputFormatters: widget.formatter,
          validator: widget.validator,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          obscureText: widget.isPassword! ? !isObscure : false,
          obscuringCharacter: '*',
          decoration: InputDecoration(
            prefixIcon: widget.iconPrefix,
            hintText: widget.hintText,
            suffixIcon: !widget.isPassword!
                ? null
                : IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: isObscure ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                  ),
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
