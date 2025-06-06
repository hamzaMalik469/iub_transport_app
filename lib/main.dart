import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:transport_app_iub/src/features/authentication/firebase_authentication/auth_state.dart';
import 'package:transport_app_iub/src/uitils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: MyThemeData.lightTheme,
        darkTheme: MyThemeData.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const AuthStateChecker());
  }
}
