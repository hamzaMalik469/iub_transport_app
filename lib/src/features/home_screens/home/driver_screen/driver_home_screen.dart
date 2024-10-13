import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transport_app_iub/src/constants/images_strings.dart';
import 'package:transport_app_iub/src/features/authentication/firebase_authentication/firebase_service.dart';
import 'package:transport_app_iub/src/features/authentication/screens/wellcom_screen/wellcome_screen.dart';
import 'package:transport_app_iub/src/features/home_screens/home/common_widgets/bus_tile.dart';
import 'package:transport_app_iub/src/features/home_screens/home/driver_screen/driver_map_screen.dart';
import 'package:transport_app_iub/src/features/home_screens/model/bus_model.dart';
import 'package:get/get.dart';

class DriverHomeScreen extends StatefulWidget {
  final String? userId;

  const DriverHomeScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  Buses bus = Buses();
  bool locationEnabled = false;
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
    _getCurrentLocation();
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

    // If permissions are granted and services are enabled, get current location
    _getCurrentLocation();
  }

  // Helper function to get document from Firebase
  Future<DocumentSnapshot> _getDocument(
      String collection, String? docId) async {
    return FirebaseFirestore.instance.collection(collection).doc(docId).get();
  }

  // Get Bus info from Firebase
  Future<void> _getBus() async {
    try {
      DocumentSnapshot userDoc = await _getDocument('users', widget.userId);
      if (userDoc.exists) {
        var busId = userDoc['busId'];
        DocumentSnapshot busDoc = await _getDocument('buses', busId);
        if (busDoc.exists) {
          setState(() {
            bus.fromJson(busDoc.data() as Map<String, dynamic>);
            locationEnabled = bus.locationEnable ?? false;
          });
          if (locationEnabled) _startListeningToLocationChanges();
        }
      }
    } catch (e) {
      print('Error fetching bus data: $e');
    }
  }

  // Start listening to location changes
  void _startListeningToLocationChanges() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _updateLocationInFirestore(position);
      setState(() {
        busLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  // Update the user's location in Firestore
  Future<void> _updateLocationInFirestore(Position position) async {
    try {
      DocumentSnapshot userDoc = await _getDocument('users', widget.userId);
      if (userDoc.exists) {
        var busId = userDoc['busId'];
        await FirebaseFirestore.instance.collection('buses').doc(busId).update({
          'live location': GeoPoint(position.latitude, position.longitude),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        print('Location updated: ${position.latitude}, ${position.longitude}');
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  // Enable or disable location updates for the driver
  Future<void> _enableDisableLocation(bool update) async {
    try {
      DocumentSnapshot userDoc = await _getDocument('users', widget.userId);
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

  // Get current location
  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     setState(() {
  //       currentLocation = LatLng(position.latitude, position.longitude);
  //       locationMessage = 'Location fetched successfully';
  //     });
  //   } catch (e) {
  //     setState(() {
  //       locationMessage = 'Error fetching location: $e';
  //     });
  //   }
  // }

  void _getCurrentLocation() async {
    try {
      Geolocator.getPositionStream().listen((Position position) {
        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
          _updateBusLocationInFirestore(position);
        });
        _mapController.animateCamera(
          CameraUpdate.newLatLng(currentLocation),
        );
      });
    } catch (e) {
      setState(() {
        locationMessage = 'Error fetching location: $e';
      });
    }
  }

  void _updateBusLocationInFirestore(Position position) async {
    FirebaseFirestore.instance.collection('buses').doc(widget.userId).update({
      'currentLocation': GeoPoint(position.latitude, position.longitude),
      'lastUpdated': Timestamp.now(),
    });
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
                    _enableDisableLocation(locationEnabled);
                    if (locationEnabled) {
                      _getCurrentLocation();
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
                    userId: widget.userId,
                  ));
            },
          ),
          const SizedBox(height: 20),
          Text(
              'Current Location: ${currentLocation!.latitude}, ${currentLocation!.longitude}'),
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
