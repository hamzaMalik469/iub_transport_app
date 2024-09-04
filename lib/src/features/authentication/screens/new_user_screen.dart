import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transport_app_iub/src/constants/colors_string.dart';
import 'package:transport_app_iub/src/constants/text_strings.dart';
import 'package:transport_app_iub/src/features/authentication/screens/sing_in_screen.dart';

class NewUserScreen extends StatelessWidget {
  const NewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 500,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey
                        .withOpacity(0.4), // Shadow color with opacity
                    spreadRadius: 10, // How much the shadow spreads
                    blurRadius: 7, // How blurry the shadow is
                    offset: const Offset(0, 3), // Shadow position (x, y)
                  ),
                ],
                gradient: const LinearGradient(
                  colors: [
                    iubColor,
                    Colors.white,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(160),
                  bottomRight: Radius.circular(160),
                )),
            child: Image.asset(
              'assets/images/busIUB.png',
              alignment: Alignment.centerLeft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 57,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  wellcomeText,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  decriptionText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  },
                  child: Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.4), // Shadow color with opacity
                            spreadRadius: 5, // How much the shadow spreads
                            blurRadius: 7, // How blurry the shadow is
                            offset:
                                const Offset(0, 3), // Shadow position (x, y)
                          ),
                        ],
                        gradient: const LinearGradient(
                          colors: [
                            iubColor,
                            Colors.white,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(20))),
                    child: Center(
                      child: Text('Sign In',
                          style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
