import 'package:flutter/material.dart';

TextField myTextField(Widget myIcon, String hintText, bool obscure) {
  return TextField(
    obscureText: obscure,
    decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        fillColor: Colors.white38,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white60),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        hintText: hintText,
        prefixIcon: myIcon),
  );
}
