import 'package:flutter/material.dart';

class StatusIdentifier extends StatelessWidget {
  const StatusIdentifier(
      {super.key, required this.boxColor, required this.text});

  final Color boxColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: boxColor),
          ),
          SizedBox(
            width: 5,
          ),
          Text(text.toUpperCase())
        ],
      ),
    );
  }
}
