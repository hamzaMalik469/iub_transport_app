import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/common_widgets/custom_container/container_common_widgets.dart';
import 'package:transport_app_iub/src/features/authentication/screens/sign_up_screen/sign_up_form.dart';
import 'package:transport_app_iub/src/features/authentication/screens/sign_up_screen/header.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: custom_container_color_gradient()),
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //header start
                header(),
                //header end

                SizedBox(
                  height: 20,
                ),
                //form start
                SignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
