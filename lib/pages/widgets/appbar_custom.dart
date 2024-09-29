import 'package:flutter/material.dart';

AppBar appBarCustom(String title, [Widget? leading]) => AppBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      )),
      backgroundColor: const Color(0XFFFF9D9D),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF570808), fontWeight: FontWeight.bold),
      ),
      leadingWidth: 180.0,
      leading: leading,
    );
