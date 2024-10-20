import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  textTheme: GoogleFonts.montserratTextTheme(
    const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
      titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
      titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
      bodyMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black),
      bodySmall: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
      labelMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
      labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      labelSmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.red,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),

  
);
