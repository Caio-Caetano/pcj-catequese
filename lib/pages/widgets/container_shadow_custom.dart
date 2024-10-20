import 'package:flutter/material.dart';

class ContainerShadowCustom extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  const ContainerShadowCustom({super.key, required this.height, required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFFFFCCCC),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: [
          BoxShadow(offset: Offset(3, 4), blurRadius: 4, color: Color.fromRGBO(0, 0, 0, 0.25)),
        ],
      ),
      child: child,
    );
  }
}
