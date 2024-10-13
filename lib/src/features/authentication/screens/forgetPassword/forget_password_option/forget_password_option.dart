import 'package:flutter/material.dart';

Future<dynamic> forgetPasswordOption(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: const Row(
              children: [
                Icon(
                  Icons.mail_outline,
                  size: 60,
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
