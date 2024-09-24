import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/common_widgets/button.dart';
import 'package:transport_app_iub/src/constants/images_strings.dart';
import 'package:transport_app_iub/src/features/authentication/firebase_authentication/firebase_service.dart';
import 'package:transport_app_iub/src/features/home_screens/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getData() async {
    var result = await _firestore.collection('bus').get();
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 73, 113),
        title: const Text('Map'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: const Text('Log out'))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ListTile(
                  leading: Image(image: AssetImage(wellcomeScreenImage)),
                  title: const Text('ABC-2345'),
                  subtitle: const Text('Campus to Bypass'),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapScreen()));
                    },
                    child: myButton('Live Location'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
