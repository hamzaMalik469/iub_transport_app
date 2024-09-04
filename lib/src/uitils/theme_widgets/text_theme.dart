// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextTheme {
  static TextTheme LightTextTheme = TextTheme(
    displayLarge: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 30,
    ),
    bodyMedium: GoogleFonts.roboto(),
  );

  static TextTheme DarkTextTheme = TextTheme(
      displayLarge:
          GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.bold),
      bodyMedium: GoogleFonts.roboto(color: Colors.white38));
}
