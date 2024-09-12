import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transport_app_iub/src/constants/colors_string.dart';

Container myButton(
  String text,
) {
  return Container(
    width: double.infinity,
    height: 40,
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4), // Shadow color with opacity
            spreadRadius: 5, // How much the shadow spreads
            blurRadius: 7, // How blurry the shadow is
            offset: const Offset(0, 2), // Shadow position (x, y)
          ),
        ],
        gradient: const LinearGradient(
          colors: [
            iubColor,
            Colors.white,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(20), right: Radius.circular(20))),
    child: Center(
      child: Text(text.toUpperCase(),
          style: GoogleFonts.roboto(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
    ),
  );
}
