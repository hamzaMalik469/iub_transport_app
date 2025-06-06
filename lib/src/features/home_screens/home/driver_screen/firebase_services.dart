import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:transport_app_iub/src/features/home_screens/model/bus_model.dart';

class MyFirebaseService {
  // A variable to hold the stream subscription
  static late StreamSubscription<Position> _positionStreamSubscription;

  // Get the current user bus data
  static Future<Buses?> getBus() async {
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
          Buses bus = Buses();
          bus = await bus.fromJson(busDoc as Map<String, dynamic>);
          return bus;
        }
      }
    } catch (e) {
      print('Error fetching bus data: $e');
    }
    return null;
  }

  // Method to start listening to location updates
  static Future<void> startTracking() async {
    _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high, // High accuracy for vehicle tracking
      distanceFilter: 0, // Trigger whenever there is a location change
    )).listen((Position position) async {
      // Every time location updates, send data to Firestore
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
              .update({
            'live location': GeoPoint(position.latitude, position.longitude),
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        print('Error updating location: $e');
      }
    });
  }

  // Method to stop location tracking
  static Future<void> stopTracking() async {
    try {
      // Cancel the location stream subscription
      await _positionStreamSubscription.cancel();
      print('Location tracking stopped');
    } catch (e) {
      print('Error stopping location tracking: $e');
    }
  }
}
