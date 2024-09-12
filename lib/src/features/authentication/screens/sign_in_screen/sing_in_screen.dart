import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/common_widgets/custon_container/container_common_widgets.dart';
import 'package:transport_app_iub/src/constants/text_strings.dart';
import 'package:transport_app_iub/src/features/authentication/screens/sign_in_screen/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: custom_container_color_gradient(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(signIn.toUpperCase(),
                  style: Theme.of(context).textTheme.displayLarge),
              Text('Sign in to your Account',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(
                height: 20,
              ),
              const SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}
