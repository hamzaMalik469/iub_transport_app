import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/common_widgets/button.dart';
import 'package:transport_app_iub/src/common_widgets/custom_container/custom_dialog_box.dart';
import 'package:transport_app_iub/src/common_widgets/text_field.dart';
import 'package:transport_app_iub/src/constants/text_strings.dart';
import 'package:transport_app_iub/src/features/authentication/firebase_authentication/firebase_service.dart';
import 'package:transport_app_iub/src/features/home_screens/home_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final CollectionReference _collectionReference =
  //     FirebaseFirestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassswordController =
      TextEditingController();
  String errorMessage = '';
  String matchPassword = '';
  bool _isPasswordVisible = false;
  bool _obsecure = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Sign Up through firebase Methode and store user personal data in firebase
  Future<void> signUpWithEmailAndPassword() async {
    try {
      if (_formKey.currentState!.validate()) {
        dialog_method(const CircularProgressIndicator(), context);
        String email = emailController.text.trim();
        String password = passwordController.text.trim();
        User? user = await _auth.registerWithEmailAndPassword(email, password);

        if (user != null) {
          // Map<String, dynamic> saveUserData = {
          //   'username': nameController.text,
          //   'phone number': phoneNumberController.text,
          //   'email': emailController.text,
          //   'signUpTime': Timestamp.now(),
          // };
          // _collectionReference.add(saveUserData);
          await _firestore.collection('users').doc(user.uid).set({
            'username': nameController.text,
            'phone number': phoneNumberController.text,
            'email': emailController.text,
            'signUpTime': Timestamp.now(),
          });
          if (!mounted) return; // Check if the widget is still mounted

          // Now it is safe to navigate
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup Successful!')),
          );
        } else {
          dialog_method(const Text('User Alread Found!'), context);
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        Navigator.pop(context);
        dialog_method(Text(errorMessage), context);
      });
    }
  }

  // Username validation
  String? _validateUsername(String? value) {
    // Regular expression for the specific pattern "F22NDOCS1M01142"
    String pattern =
        r'^[F,S]{1}[2]{1}[0-9]{1}[N]{1}[D]{1}[O]{1}[A-Z]{2}[0-9]{1}[M,E]{1}[0-9]{5}$';
    RegExp regex = RegExp(pattern);
    value = value?.toUpperCase();
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Invalid format. Follow F22NDOCS1M01142 format';
    }
    return null; // Username is valid
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Username field
          TextFormField(
              controller: nameController,
              decoration:
                  inputDecoration('Username', const Icon(Icons.person), null),
              validator: _validateUsername),
          const SizedBox(height: 16),
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
          // Phone number field
          TextFormField(
            controller: phoneNumberController,
            decoration: inputDecoration(
                'Phone Numerber', const Icon(Icons.phone), null),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length != 11) {
                return 'Lenth of number is invalid, it should be 11';
              }
              if (!RegExp(r'^[0,92]{1}[3]{1}[0-9]{2}[0-9]{7}$')
                  .hasMatch(value)) {
                return 'Please enter a valid phone number';
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
          const SizedBox(height: 32),
          // Sign Up Button
          GestureDetector(
              onTap: signUpWithEmailAndPassword, child: myButton(signUp))
        ],
      ),
    );
  }
}
