import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transport_app_iub/src/constants/images_strings.dart';
import 'package:transport_app_iub/src/features/authentication/firebase_authentication/firebase_service.dart';
import 'package:transport_app_iub/src/features/authentication/screens/wellcom_screen/wellcome_screen.dart';
import 'package:transport_app_iub/src/features/home_screens/home/common_widgets/bus_tile.dart';
import 'package:transport_app_iub/src/features/home_screens/home/driver_screen/driver_map_screen.dart';
import 'package:transport_app_iub/src/features/home_screens/home/driver_screen/firebase_services.dart';
import 'package:transport_app_iub/src/features/home_screens/model/bus_model.dart';
import 'package:get/get.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  Buses bus = Buses();
  var locationEnabled = false;
  final AuthService _auth = AuthService();
  LatLng currentLocation = const LatLng(0, 0);
  LatLng? busLocation;
  String locationMessage = "";
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _getBus();
    _checkLocationServicesAndPermission();
    if (bus.locationEnable == true) {}
  }

  // Get Current user Id
  Future<String?> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  // Check for location permissions and services
  Future<void> _checkLocationServicesAndPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt user to enable location services
      setState(() {
        locationMessage = 'Location services are disabled.';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationMessage = 'Location permissions are denied.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationMessage = 'Location permissions are permanently denied.';
      });
      return;
    }
  }

  // // Helper function to get document from Firebase
  Future<DocumentSnapshot> _getDocument(
      String collection, String? docId) async {
    return FirebaseFirestore.instance.collection(collection).doc(docId).get();
  }

  // // Get Bus info from Firebase
  Future<void> _getBus() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        var busId = userDoc['busId'];
        DocumentSnapshot busDoc = await FirebaseFirestore.instance
            .collection('buses')
            .doc(busId)
            .get();
        if (busDoc.exists) {
          setState(() {
            bus.fromJson(busDoc.data() as Map<String, dynamic>);
            currentLocation =
                LatLng(bus.driverLoc!.latitude, bus.driverLoc!.longitude);
            locationEnabled = bus.locationEnable ?? false;
          });
        }
      }
    } catch (e) {
      print('Error fetching bus data: $e');
    }
  }

  // // Enable or disable location updates for the driver
  Future<void> _enableDisableLocation(bool update) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        var busId = userDoc['busId'];
        await FirebaseFirestore.instance
            .collection('buses')
            .doc(busId)
            .update({'location enable': update});
        print('Location enable status updated successfully');
      }
    } catch (e) {
      print('Error updating location enable status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 100),
            ListTile(
              leading: ClipRRect(
                child: Image(image: AssetImage(wellcomeScreenImage)),
              ),
              title: Text(bus.plateNumber ?? 'No Plate Number'),
              subtitle: Text(bus.routeName ?? 'No Route Name'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Divider(color: Colors.grey),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text('Edit Bus Info'.toUpperCase()),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text('Settings'.toUpperCase()),
                ),
                const SizedBox(height: 10),
                ListTile(
                  onTap: () {
                    _auth.signOut();
                    Get.to(() => const WellcomeScreen());
                  },
                  leading: const Icon(Icons.arrow_back_sharp),
                  title: Text('Log Out'.toUpperCase()),
                ),
              ],
            )
          ],
        ),
      ),
      appBar: AppBar(
        actions: const [
          // IconButton(
          //   onPressed: () {
          //     _getCurrentLocation();
          //   },
          //   icon: const Icon(Icons.refresh),
          // ),
        ],
        backgroundColor: Colors.grey[700],
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    locationEnabled = !locationEnabled;
                    bus.locationEnable = locationEnabled;
                    _enableDisableLocation(locationEnabled);
                    if (locationEnabled == true) {
                      MyFirebaseService.startTracking();
                    } else {
                      MyFirebaseService.stopTracking();
                    }
                  });
                },
                icon: Icon(
                  locationEnabled ? Icons.location_on : Icons.location_off,
                  size: 80,
                  color: locationEnabled ? Colors.green : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          BusTile(
            bus: bus,
            onTap: () async {
              Get.to(() => DriverMapScreen(
                    bus: bus,
                    currentLocation: currentLocation,
                    userId: getCurrentUserId().toString(),
                  ));
            },
          ),
          const SizedBox(height: 20),
          Text(
              'Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}'),
          if (busLocation != null)
            Text(
                'Bus Location: ${busLocation!.latitude}, ${busLocation!.longitude}'),
          if (locationMessage.isNotEmpty)
            Text(locationMessage, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
