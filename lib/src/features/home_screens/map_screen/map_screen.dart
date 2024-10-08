import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:transport_app_iub/src/constants/text_strings.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      required this.source,
      required this.destination,
      required this.stops});
  final GeoPoint? source;
  final GeoPoint? destination;
  final List<GeoPoint>? stops;

  static const CameraPosition myLoc = CameraPosition(
    target: LatLng(29.9927000, 73.2622560),
    zoom: 14.4746,
  );

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  late GoogleMapController _controller;
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _getPolyline();
  }

  // Method to set markers for source, destination, and stops
  void _setMarkers() {
    // Marker for source
    _markers.add(
      Marker(
        markerId: MarkerId('source'),
        position: LatLng(widget.source!.latitude, widget.source!.longitude),
        infoWindow: InfoWindow(title: 'Source'),
      ),
    );

    // Marker for destination
    _markers.add(
      Marker(
        markerId: MarkerId('destination'),
        position:
            LatLng(widget.destination!.latitude, widget.destination!.longitude),
        infoWindow: InfoWindow(title: 'Destination'),
      ),
    );

    // Add markers for stops if any
    if (widget.stops != null) {
      for (int i = 0; i < widget.stops!.length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId('stop_$i'),
            position:
                LatLng(widget.stops![i].latitude, widget.stops![i].longitude),
            infoWindow: InfoWindow(title: 'Stop ${i + 1}'),
          ),
        );
      }
    }
  }

  // Fetch polyline route from Google Directions API
  Future<void> _getPolyline() async {
    String url = _buildDirectionsUrl();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('Response Data: ${response.body}');
      Map<String, dynamic> data = json.decode(response.body);
      if (data["routes"].isNotEmpty) {
        var route = data["routes"][0];
        var polyline = route["overview_polyline"]["points"];
        polylineCoordinates = _decodePolyline(polyline);
        _addPolyline();
      }
    } else {
      print("Failed to fetch directions");
    }
  }

  // Build URL for the Google Directions API
  String _buildDirectionsUrl() {
    String baseUrl = "https://maps.googleapis.com/maps/api/directions/json?";
    String origin =
        "origin=${widget.source!.latitude},${widget.source!.longitude}";
    String destination =
        "destination=${widget.destination!.latitude},${widget.destination!.longitude}";

    // Check if there are stops
    String waypoints = "";
    if (widget.stops != null && widget.stops!.isNotEmpty) {
      List<String> stopCoordinates = widget.stops!
          .map((stop) => "${stop.latitude},${stop.longitude}")
          .toList();
      waypoints = "&waypoints=${stopCoordinates.join('|')}";
    }

    // Your Google Maps API key (replace with your own)
    String apiKey = mapApi;

    // Return full URL
    return "$baseUrl$origin&$destination$waypoints&key=$apiKey";
  }

  // Decode polyline using polyline algorithm
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng point = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      polyline.add(point);
    }

    return polyline;
  }

  // Add polyline to the map
  void _addPolyline() {
    final Polyline polyline = Polyline(
      polylineId: const PolylineId("road_following_polyline"),
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() {
      _polylines.add(polyline);
    });
  }

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
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.source!.latitude, widget.source!.longitude),
            zoom: 14.4746),
        zoomControlsEnabled: true,
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
