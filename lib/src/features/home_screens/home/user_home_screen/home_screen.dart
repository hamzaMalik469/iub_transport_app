import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transport_app_iub/src/features/authentication/firebase_authentication/firebase_service.dart';
import 'package:transport_app_iub/src/features/home_screens/home/common_widgets/bus_tile.dart';
import 'package:transport_app_iub/src/features/home_screens/home/user_home_screen/user_map_screen.dart';
import 'package:transport_app_iub/src/features/home_screens/model/bus_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // FirestoreServices services = FirestoreServices();
  List<Buses> busesList = [];

  bool isLoading = true; // Loading state

  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchBuses();
    // fetchBuses();
  }

  Future<void> fetchBuses() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('buses').get();

      for (var doc in querySnapshot.docs) {
        Buses bus = Buses();
        bus.fromJson(doc.data() as Map<String, dynamic>);
        busesList.add(bus);
      }

      // Update the loading state
      setState(() {
        isLoading = false; // Stop loading once data is fetched
      });
    } catch (e) {
      // You may want to set an error state here
      error = 'Error fetching buses:$e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 73, 113),
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              _auth.signOut();
            },
            child: const Text('Log out'),
          ),
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
            color: Colors.white,
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : busesList.isEmpty
              ? const Center(
                  child:
                      Text('No buses available.')) // Show message if no buses
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  scrollDirection: Axis.vertical,
                  itemCount: busesList.length,
                  itemBuilder: (context, index) {
                    final bus = busesList[index];
                    final busId = busesList[index].id;

                    final source = busesList[index].startingPoint;
                    final destination = busesList[index].endingPoint;
                    final List<GeoPoint>? stops = busesList[index].stops;

                    final locationEnable = busesList[index].locationEnable;
                    return BusTile(
                      bus: bus,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapScreen(
                                      busId: busId,
                                      locationEnable: locationEnable,
                                      source: destination,
                                      destination: source,
                                      stops: stops,
                                    )));
                      },
                    );
                  },
                ),
    );
  }
}
