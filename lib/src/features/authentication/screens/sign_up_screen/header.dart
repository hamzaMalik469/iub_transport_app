import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/constants/text_strings.dart';

class header extends StatelessWidget {
  const header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(signUp.toUpperCase(),
            style: Theme.of(context).textTheme.displayLarge),
        Text(signUpSubtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
