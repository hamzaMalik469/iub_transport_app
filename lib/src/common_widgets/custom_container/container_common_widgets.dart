import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/constants/colors_string.dart';

LinearGradient custom_container_color_gradient() {
  return const LinearGradient(
    colors: [
      iubColor,
      Colors.white,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}

BoxShadow custom_container_shadow() {
  return BoxShadow(
    color: Colors.grey.withOpacity(0.4), // Shadow color with opacity
    spreadRadius: 10, // How much the shadow spreads
    blurRadius: 7, // How blurry the shadow is
    offset: const Offset(0, 3), // Shadow position (x, y)
  );
}
