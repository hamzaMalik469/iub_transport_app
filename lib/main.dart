import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/features/authentication/screens/new_user_screen.dart';
import 'package:transport_app_iub/src/uitils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: MyThemeData.lightTheme,
        darkTheme: MyThemeData.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const NewUserScreen());
  }
}
