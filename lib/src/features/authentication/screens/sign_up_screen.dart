import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/common_widgets/button.dart';
import 'package:transport_app_iub/src/common_widgets/text_field.dart';
import 'package:transport_app_iub/src/constants/colors_string.dart';
import 'package:transport_app_iub/src/features/authentication/screens/home_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              iubColor,
              Colors.white38,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sign Up', style: Theme.of(context).textTheme.displayLarge),
              Text('Creat your Account',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(
                height: 20,
              ),
              myTextField(const Icon(Icons.person), 'Enter Name', false),
              const SizedBox(
                height: 20,
              ),
              myTextField(const Icon(Icons.email), 'Enter Email', false),
              const SizedBox(
                height: 20,
              ),
              myTextField(const Icon(Icons.password), 'Enter Password', true),
              const SizedBox(
                height: 20,
              ),
              myTextField(const Icon(Icons.password), 'Confirm Password', true),
              const SizedBox(
                height: 30,
              ),
              myButton(context, 300, 40, 'Sign Up', const HomeScreen())
            ],
          ),
        ),
      ),
    );
  }
}
