import 'package:flutter/material.dart';

Future<dynamic> dialog_method(Widget child, BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => Center(
            child: Container(
              child: child,
            ),
          ));
}
