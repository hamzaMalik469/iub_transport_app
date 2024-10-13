import 'package:flutter/material.dart';

class MapStyleTile extends StatelessWidget {
  MapStyleTile(
      {super.key, required this.onTap, required this.icon, required this.text});

  VoidCallback? onTap;
  Icon? icon;
  String? text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon,
      title: Text(text.toString()),
    );
  }
}
