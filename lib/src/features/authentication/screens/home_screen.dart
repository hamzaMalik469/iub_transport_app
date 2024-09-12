import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/features/authentication/firebase_authentication/firebase_service.dart';
import 'package:transport_app_iub/src/features/authentication/screens/wellcom_screen/wellcome_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _auth.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WellcomeScreen(),
                  ));
            },
            child: const Text('Logg out')),
      ),
    );
  }
}
