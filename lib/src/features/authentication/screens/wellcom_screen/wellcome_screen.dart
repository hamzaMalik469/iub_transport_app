import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/features/authentication/screens/wellcom_screen/widgets/footer.dart';
import 'package:transport_app_iub/src/features/authentication/screens/wellcom_screen/widgets/headerDesign.dart';

class WellcomeScreen extends StatelessWidget {
  const WellcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HeaderWellcomeScreen(mediaQuery: mediaQuery),
            FooterWellcomeScreen(mediaQuery: mediaQuery),
          ],
        ),
      ),
    );
  }
}
