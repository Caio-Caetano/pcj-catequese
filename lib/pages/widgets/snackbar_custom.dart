import 'package:flutter/material.dart';

SnackBar createSnackBar(String text) => SnackBar(
      content: Text(text),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    );
