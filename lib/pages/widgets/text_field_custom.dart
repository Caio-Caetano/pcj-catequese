// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextFieldCustom extends StatefulWidget {
  const TextFieldCustom({
    Key? key,
    required this.controller,
    this.formatter,
    this.validator,
    this.onChanged,
    this.labelText,
    this.iconPrefix,
    this.hintText,
    this.readOnly = false,
    this.isPassword = false,
    this.labelColor,
    this.maxLines = 1,
  }) : super(key: key);

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

  final int? maxLines;

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
        if (widget.labelText != null)
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
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            prefixIcon: widget.iconPrefix,
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.labelLarge,
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
