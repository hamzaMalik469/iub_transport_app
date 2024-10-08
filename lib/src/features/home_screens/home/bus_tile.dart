import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/constants/images_strings.dart';
import 'package:transport_app_iub/src/features/home_screens/model/bus_model.dart';

// ignore: must_be_immutable
class BusTile extends StatelessWidget {
  BusTile({super.key, required this.bus, required this.onTap});

  final Buses bus;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      margin: const EdgeInsets.all(10),
      height: mediaQuery.size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[700],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ListTile(
            onTap: onTap,
            leading: Image(image: AssetImage(wellcomeScreenImage)),
            title: Text(bus?.plateNumber ?? 'No Plate Number'),
            titleTextStyle: Theme.of(context).textTheme.displayLarge,
            subtitle: Text(bus?.routeName ?? 'No Route Name'),
          ),
        ],
      ),
    );
  }
}
