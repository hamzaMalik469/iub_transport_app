import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transport_app_iub/src/features/authentication/firebase_authentication/firebase_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final AuthService _auth = AuthService();

  // static final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _markers.add(
      const Marker(
        markerId: MarkerId('initialMarker'),
        position: LatLng(29.9927000, 73.2622560),
        infoWindow: InfoWindow(
          title: 'Marker Title',
          snippet: 'Marker Description',
        ),
      ),
    );
  }

  static const CameraPosition myLoc = CameraPosition(
    target: LatLng(29.9927000, 73.2622560),
    zoom: 14.4746,
  );
  final Set<Marker> _markers = {};
  static const CameraPosition _kLake = CameraPosition(
      // bearing: 192.8334901395799,
      target: LatLng(30.001733567125395, 73.27131519479785),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: true,
      ),
      body: GoogleMap(
        markers: _markers,
        mapType: MapType.normal,
        initialCameraPosition: myLoc,
        zoomControlsEnabled: false,

        // onMapCreated: (GoogleMapController controller) {
        //   _controller.complete(controller);
        // },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.location_on_outlined),
      ),
    );
  }
}
