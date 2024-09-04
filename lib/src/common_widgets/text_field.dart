import 'package:flutter/material.dart';

TextField myTextField(Widget myIcon, String hintText, bool obscure) {
  return TextField(
    obscureText: obscure,
    decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        prefixIcon: myIcon),
  );
}
