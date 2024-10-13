import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:transport_app_iub/src/features/home_screens/home/driver_screen/driver_home_screen.dart';
import 'package:transport_app_iub/src/features/home_screens/home/user_home_screen/home_screen.dart';
import 'package:transport_app_iub/src/features/authentication/screens/wellcom_screen/wellcome_screen.dart';

class AuthStateChecker extends StatelessWidget {
  const AuthStateChecker({super.key});

  Future<String?> _getUserRole(String userId) async {
    // Fetch user role from Firestore
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc['role']; // Return 'driver' or 'user'
    }
    return null; // If role is not found
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var userId = snapshot.data?.uid;
          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            // User is logged in, fetch their role
            return FutureBuilder<String?>(
              future: _getUserRole(snapshot.data!.uid),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Loading state while fetching role
                } else if (roleSnapshot.hasError) {
                  return Center(
                    child:
                        Text('Error fetching user role: ${roleSnapshot.error}'),
                  );
                }

                if (roleSnapshot.hasData) {
                  String? role = roleSnapshot.data;
                  // Navigate based on user role
                  if (role == 'driver') {
                    return DriverHomeScreen(
                        userId: userId); // Navigate to driver screen
                  } else if (role == 'user') {
                    return const HomeScreen(); // Navigate to user screen
                  } else {
                    return const WellcomeScreen(); // Fallback if role is unknown
                  }
                } else {
                  return const WellcomeScreen(); // Fallback if role is not found
                }
              },
            );
          } else {
            return const WellcomeScreen(); // Redirect to sign-in if logged out
          }
        } else {
          return const Center(
              child: CircularProgressIndicator()); // Loading state
        }
      },
    );
  }
}
