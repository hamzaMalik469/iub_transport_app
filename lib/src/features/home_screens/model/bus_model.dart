import 'package:cloud_firestore/cloud_firestore.dart';

class Buses {
  String? driverName;
  GeoPoint? endingPoint; // Firestore GeoPoint
  String? plateNumber;
  String? routeName;
  GeoPoint? startingPoint; // Firestore GeoPoint
  List<GeoPoint>? stops; // Firestore GeoPoint

  Buses({
    this.driverName,
    this.endingPoint,
    this.plateNumber,
    this.routeName,
    this.startingPoint,
    this.stops,
  });

  // Method to convert Firestore data to Buses object
  fromJson(Map<String, dynamic> json) {
    driverName = json['Driver Name'];
    endingPoint = json['Ending point'] != null
        ? json['Ending point'] as GeoPoint
        : null; // Handle null for endingPoint
    plateNumber = json['Plate Number'];
    routeName = json['Route name'];
    startingPoint = json['Starting point'] != null
        ? json['Starting point'] as GeoPoint
        : null; // Handle null for startingPoint

    if (json['Stops'] != null) {
      stops = <GeoPoint>[]; // Initialize the list of GeoPoints
      for (var stop in json['Stops']) {
        if (stop != null) {
          stops!.add(stop as GeoPoint); // Firestore GeoPoint
        }
      }
    }
  }

  // Method to convert Buses object back to JSON (optional, for saving to Firestore)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Driver Name'] = driverName;
    if (endingPoint != null) {
      data['Ending Point'] = endingPoint; // Firestore GeoPoint
    }
    data['Plate Number'] = plateNumber;
    data['Route Name'] = routeName;
    if (startingPoint != null) {
      data['Starting Point'] = startingPoint; // Firestore GeoPoint
    }
    if (stops != null) {
      data['Stops'] = stops!.map((v) => v).toList(); // Firestore GeoPoint
    }
    return data;
  }
}
