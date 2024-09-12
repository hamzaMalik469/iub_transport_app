import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/features/authentication/screens/home_screen.dart';
import 'package:transport_app_iub/src/features/authentication/screens/wellcom_screen/wellcome_screen.dart';

class AuthStateChecker extends StatelessWidget {
  const AuthStateChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return HomeScreen(); // Redirect to home if logged in
          } else {
            return const WellcomeScreen(); // Redirect to sign-in if logged out
          }
        } else {
          return const CircularProgressIndicator(); // Loading state
        }
      },
    );
  }
}
