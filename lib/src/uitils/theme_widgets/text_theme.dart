// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextTheme {
  static TextTheme LightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 20,
    ),
    bodyMedium: GoogleFonts.roboto(),
  );

  static TextTheme DarkTextTheme = TextTheme(
      displayLarge: GoogleFonts.roboto(),
      // displayLarge: TextStyle(
      //   fontWeight: FontWeight.bold,
      //   color: Colors.white,
      //   fontSize: 25,
      // ),
      bodyMedium: TextStyle(color: Colors.white));
}
