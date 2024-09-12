import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/common_widgets/custon_container/container_common_widgets.dart';
import 'package:transport_app_iub/src/constants/images_strings.dart';

class HeaderWellcomeScreen extends StatelessWidget {
  const HeaderWellcomeScreen({
    super.key,
    required this.mediaQuery,
  });

  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: mediaQuery.size.height * 0.6,
      decoration: BoxDecoration(
        boxShadow: [
          custom_container_shadow(),
        ],
        gradient: custom_container_color_gradient(),
      ),
      child: Image.asset(
        wellcomeScreenImage,
        alignment: Alignment.centerLeft,
        height: mediaQuery.size.height * 0.4,
      ),
    );
  }
}
