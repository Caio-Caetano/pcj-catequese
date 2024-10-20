import 'package:flutter/material.dart';

AppBar appBarCustom(String title, [Widget? leading]) => AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      backgroundColor: const Color(0XFFFFA4A4),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
            color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
      ),
      leadingWidth: 180.0,
      leading: leading,
    );
