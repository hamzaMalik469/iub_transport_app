// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transport_app_iub/src/features/home_screens/model/bus_model.dart';

class DriverMapScreen extends StatefulWidget {
  final String? userId;
  LatLng? currentLocation;
  final Buses? bus;

  DriverMapScreen({
    super.key,
    required this.userId,
    required this.currentLocation,
    required this.bus,
  });

  @override
  State<DriverMapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<DriverMapScreen> {
  final Set<Marker> _markers = {};
  late GoogleMapController _controller;
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  String _locationMessage = "";
  bool serviceEnabled = false;
  LocationPermission? permission;
  Buses bus = Buses();

  @override
  void initState() {
    super.initState();
    _getBusData(); // Load bus data on initialization
    _getCurrentLocation(); // Fetch the current location
  }

  Future<void> _getBusData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        var busId = userDoc['busId'];
        DocumentSnapshot busDoc = await FirebaseFirestore.instance
            .collection('buses')
            .doc(busId)
            .get();

        setState(() {
          bus.fromJson(busDoc.data() as Map<String, dynamic>);
        });
      }
    } catch (e) {
      print('Error retrieving bus data: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = 'Location permissions are permanently denied.';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      widget.currentLocation = LatLng(position.latitude, position.longitude);
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });

    _setMarkers();
  }

  void _setMarkers() {
    _markers.clear();

    final BitmapDescriptor customIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

    if (widget.bus?.startingPoint != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('source'),
          position: LatLng(widget.bus!.startingPoint!.latitude,
              widget.bus!.startingPoint!.longitude),
          infoWindow: const InfoWindow(title: 'Source'),
        ),
      );
    }

    if (widget.bus?.endingPoint != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(widget.bus!.endingPoint!.latitude,
              widget.bus!.endingPoint!.longitude),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      );
    }

    if (widget.currentLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: widget.currentLocation!,
          infoWindow: const InfoWindow(title: 'Current Location'),
          icon: customIcon,
        ),
      );
    }

    if (widget.bus?.stops != null) {
      for (int i = 0; i < widget.bus!.stops!.length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId('stop_$i'),
            position: LatLng(widget.bus!.stops![i].latitude,
                widget.bus!.stops![i].longitude),
            infoWindow: InfoWindow(title: 'Stop ${i + 1}'),
          ),
        );
      }
    }

    setState(() {});
  }

  Future<void> _animateToNewPosition(LatLng targetPosition) async {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: targetPosition,
          zoom: 16.0,
          tilt: 45.0,
          bearing: 90.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        onPressed: () {
          if (widget.currentLocation != null) {
            _setMarkers();
            _animateToNewPosition(widget.currentLocation!);
          }
        },
        child: const Icon(Icons.location_on),
      ),
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: true,
      ),
      body: GoogleMap(
        markers: _markers,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: widget.currentLocation ??
              LatLng(
                bus.startingPoint!.latitude,
                bus.startingPoint!.longitude,
              ),
          zoom: 14.4746,
        ),
        zoomControlsEnabled: false,
        polylines: {
          Polyline(
            polylineId: const PolylineId('Route'),
            points: polylineCoordinates,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
