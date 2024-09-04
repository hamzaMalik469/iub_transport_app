import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/common_widgets/button.dart';
import 'package:transport_app_iub/src/common_widgets/text_field.dart';
import 'package:transport_app_iub/src/constants/colors_string.dart';
import 'package:transport_app_iub/src/features/authentication/screens/home_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
              Colors.white,
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
              Text('Sign In', style: Theme.of(context).textTheme.displayLarge),
              Text('Sign in to your Account',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(
                height: 20,
              ),
              myTextField(Icon(Icons.email), 'Enter Email', false),
              SizedBox(
                height: 30,
              ),
              myTextField(Icon(Icons.password), 'Enter Password', true),
              SizedBox(
                height: 30,
              ),
              myButton(context, 300, 40, 'Sign In', HomeScreen())
            ],
          ),
        ),
      ),
    );
  }
}
