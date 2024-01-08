import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final String textButton;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final IconData? icon;
  final Color? color;
  const ButtonCustom({super.key, required this.textButton, required this.onTap, this.padding = const EdgeInsets.all(8.0), this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Ink(
        decoration: BoxDecoration(
          color: color ?? Colors.redAccent.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) Icon(icon),
                if (icon != null) const SizedBox(width: 10),
                Text(textButton, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
