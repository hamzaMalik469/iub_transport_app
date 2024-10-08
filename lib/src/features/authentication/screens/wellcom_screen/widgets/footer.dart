import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/common_widgets/button.dart';
import 'package:transport_app_iub/src/features/authentication/screens/sign_in_screen/sing_in_screen.dart';
import 'package:transport_app_iub/src/features/authentication/screens/sign_up_screen/sign_up_screen.dart';

import '../../../../../constants/text_strings.dart';

class FooterWellcomeScreen extends StatelessWidget {
  const FooterWellcomeScreen({
    super.key,
    required this.mediaQuery,
  });

  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: mediaQuery.size.height * 0.4,
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 57,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            wellcomeText,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Text(
            decriptionText,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInScreen())),
              child: MyButton(
                text: signIn.toUpperCase(),
              )),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen())),
            child: MyButton(text: signUp.toUpperCase()),
          )
        ],
      ),
    );
  }
}
