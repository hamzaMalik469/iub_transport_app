import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/common_widgets/text_field.dart';

class ForgetPasswordForm extends StatelessWidget {
  const ForgetPasswordForm({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration:
                inputDecoration('Email', const Icon(Icons.person), null),
          ),
        ],
      ),
    );
  }
}
