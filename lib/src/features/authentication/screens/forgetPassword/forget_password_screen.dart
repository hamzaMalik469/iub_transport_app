import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/common_widgets/custom_container/container_common_widgets.dart';
import 'package:transport_app_iub/src/common_widgets/text_field.dart';
import 'package:transport_app_iub/src/constants/text_strings.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuary = MediaQuery.of(context);
    return Container(
      width: mediaQuary.size.width,
      height: mediaQuary.size.height,
      decoration: BoxDecoration(
        gradient: custom_container_color_gradient(),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(forgetPasswordTitle.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.apply(fontSizeFactor: 1)),
            Text(forgetPasswordSubtitle.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.apply(fontSizeFactor: 2)),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: inputDecoration(
                        'Enter your email', const Icon(Icons.person), null),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
