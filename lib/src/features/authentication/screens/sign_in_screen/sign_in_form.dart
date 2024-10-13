import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_app_iub/src/common_widgets/button.dart';
import 'package:transport_app_iub/src/common_widgets/custom_container/custom_dialog_box.dart';
import 'package:transport_app_iub/src/common_widgets/text_field.dart';
import 'package:transport_app_iub/src/constants/text_strings.dart';
import 'package:transport_app_iub/src/features/authentication/firebase_authentication/auth_state.dart';
import 'package:transport_app_iub/src/features/authentication/firebase_authentication/firebase_service.dart';
import 'package:transport_app_iub/src/features/authentication/screens/forgetPassword/forget_password_option/forget_password_option.dart';
import 'package:transport_app_iub/src/features/home_screens/home/driver_screen/driver_home_screen.dart';
import 'package:transport_app_iub/src/features/home_screens/home/user_home_screen/home_screen.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignInForm> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassswordController =
      TextEditingController();
  String errorMessage = '';
  bool _isPasswordVisible = false;
  bool _obsecure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signInWithEmailAndPassword() async {
    try {
      if (_formKey.currentState!.validate()) {
        dialog_method(const CircularProgressIndicator(), context);

        String email = emailController.text.trim();
        String password = passwordController.text.trim();
        User? user = await _auth.signInWithEmailAndPassword(email, password);
        if (user != null) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            var role = userDoc['role'];
            if (role == 'driver') {
              // Navigate to deriver dashboard
              Get.to(() => const AuthStateChecker());
            } else {
              // Navigate to user dashboard
              Get.to(() => const HomeScreen());
            }
          }

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signed in Successful! ${user.email}')),
          );
        } else {
          Navigator.pop(context);
          showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (context) => const Center(
                      child: AlertDialog(
                    actions: [
                      Card(
                        child: Center(
                          child: Text('Username or password is wrong!'),
                        ),
                      )
                    ],
                  )));
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) => Center(
                    child: AlertDialog(
                  actionsPadding: const EdgeInsets.all(20),
                  actions: [
                    Card(
                      child: Center(
                        child: Text(errorMessage),
                      ),
                    )
                  ],
                )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Email field
          TextFormField(
            controller: emailController,
            decoration: inputDecoration('Email', const Icon(Icons.email), null),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password field
          TextFormField(
            controller: passwordController,
            decoration: inputDecoration(
                'Password',
                const Icon(
                  Icons.fingerprint,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                        _obsecure = !_obsecure;
                      });
                    },
                    icon: _isPasswordVisible
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off))),
            obscureText: _obsecure,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: 5),

          // Forget password button
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            GestureDetector(
              onTap: () {
                forgetPasswordOption(context);
              },
              child: Text('Forget Password?',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.apply(fontSizeFactor: 0.45, color: Colors.blue[900])),
            ),
          ]),
          const SizedBox(height: 20),

          // Sign Up button
          GestureDetector(
              onTap: signInWithEmailAndPassword,
              child: MyButton(text: signIn.toUpperCase()))
        ],
      ),
    );
  }
}
