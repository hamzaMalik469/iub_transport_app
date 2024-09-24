import 'package:cloud_firestore/cloud_firestore.dart';

class GeoPoint {
  double latitude;
  double longitude;

  GeoPoint({
    required this.latitude,
    required this.longitude,
  });

  // Method to convert GeoPoint to JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Factory method to create a GeoPoint from JSON
  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    return GeoPoint(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class Bus {
  String driverName;
  String plateNumber;

  // Constructor
  Bus({
    required this.driverName,
    required this.plateNumber,
  });

  // Convert Bus object to JSON for storing in Firestore
  Map<String, dynamic> toJson() {
    return {
      'driverName': driverName,
      'plateNumber': plateNumber,
    };
  }

  // Create Bus object from JSON
  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      driverName: json['driverName'],
      plateNumber: json['plateNumber'],
    );
  }

  // Fetch routes subcollection for this bus
  Future<List<Route>> getRoutes(String busId) async {
    CollectionReference routesCollection = FirebaseFirestore.instance
        .collection('buses')
        .doc(busId)
        .collection('routes');

    QuerySnapshot querySnapshot = await routesCollection.get();
    return querySnapshot.docs
        .map((doc) => Route.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Add route to the subcollection
  Future<void> addRoute(String busId, Route route) async {
    CollectionReference routesCollection = FirebaseFirestore.instance
        .collection('buses')
        .doc(busId)
        .collection('routes');

    await routesCollection.add(route.toJson());
  }
}

class Route {
  String routeName;
  List<GeoPoint> busStops;

  Route({
    required this.routeName,
    required this.busStops,
  });

  // Convert Route object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'routeName': routeName,
      'busStops': busStops
          .map((geoPoint) =>
              {'latitude': geoPoint.latitude, 'longitude': geoPoint.longitude})
          .toList(),
    };
  }

  // Create Route object from JSON
  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      routeName: json['routeName'],
      busStops: (json['busStops'] as List)
          .map((data) => GeoPoint(
              latitude: json['latitude'], longitude: json['longitude']))
          .toList(),
    );
  }
}
