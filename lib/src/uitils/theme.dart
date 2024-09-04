import 'package:flutter/material.dart';

import 'package:transport_app_iub/src/constants/colors_string.dart';
import 'package:transport_app_iub/src/uitils/theme_widgets/text_theme.dart';

class MyThemeData {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: iubColor,
      textTheme: MyTextTheme.LightTextTheme);
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark, textTheme: MyTextTheme.DarkTextTheme);
}
