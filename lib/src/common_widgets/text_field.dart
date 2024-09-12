import 'package:flutter/material.dart';

InputDecoration inputDecoration(
    String hintText, Widget myIcon, Widget? sufixICon) {
  return InputDecoration(
      suffixIcon: sufixICon,
      labelText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      fillColor: Colors.white38,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white60),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      hintText: hintText,
      prefixIcon: myIcon);
}
