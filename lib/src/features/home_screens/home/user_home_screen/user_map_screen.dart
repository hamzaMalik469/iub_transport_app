import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transport_app_iub/src/constants/images_strings.dart';
import 'package:transport_app_iub/src/features/home_screens/home/user_home_screen/map_custom_widgets/map_style.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.source,
    required this.destination,
    required this.locationEnable,
    required this.busId,
    required this.stops,
  });

  final GeoPoint? source;
  final GeoPoint? destination;
  final List<GeoPoint>? stops;
  final bool? locationEnable;
  final String? busId;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};
  GoogleMapController? _controller; // Made controller nullable

  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  String _locationMessage = "";
  bool? serviceEnabled;
  LocationPermission? permission;

  LatLng? currentLocation;
  MapType _mapType = MapType.normal;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  LatLng busLoc = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((value) {
      trackBusLoc();
      _startListeningToLocationChanges();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    // Optionally apply map styles here or other map settings
  }

  // Track bus location live from Firebase
  void trackBusLoc() {
    _firestore.collection('buses').doc(widget.busId).snapshots().listen(
      (snapshot) {
        if (snapshot.exists) {
          var data = snapshot.data() as Map<String, dynamic>;
          GeoPoint geoPoint = data['live location'];
          setState(() {
            busLoc = LatLng(geoPoint.latitude, geoPoint.longitude);
            _updateBusMarker(busLoc);
          });
        }
      },
      onError: (error) {
        debugPrint('Error tracking bus location: $error');
      },
    );
  }

  // User current location changing listener and update the marker
  void _startListeningToLocationChanges() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    ).listen((Position position) {
      setState(() {
        LatLng userLoc = LatLng(position.latitude, position.longitude);
        _updateUserMarker(userLoc);
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    });
  }

  // Get user current location
  Future<void> _getCurrentLocation() async {
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      setState(() {
        _locationMessage = 'Location services are disabled.';
      });
      return;
    }

    // Check location permissions
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
        _locationMessage =
            'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });

    // Now that the current location is set, update the markers
    _setMarkers();
  }

  // Set markers on map for source, destination, stops
  void _setMarkers() {
    _markers.clear(); // Clear existing markers

    // Add marker for source
    _addMarker(
      widget.source,
      'source',
      'Source',
    );

    // Add marker for destination
    _addMarker(
      widget.destination,
      'destination',
      'Destination',
    );

    // Add markers for stops, if any
    if (widget.stops != null) {
      for (int i = 0; i < widget.stops!.length; i++) {
        _addMarker(
          widget.stops![i],
          'stop_$i',
          'Stop ${i + 1}',
        );
      }
    }
    setState(() {}); // Ensure UI gets updated with new markers
  }

  // Add individual marker to the map
  void _addMarker(GeoPoint? location, String markerId, String title) {
    if (location != null) {
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: title),
        ),
      );
    }
  }

  // Update the bus marker on the map when the location changes
  void _updateBusMarker(LatLng location) async {
    _markers
        .removeWhere((marker) => marker.markerId == const MarkerId('driver'));

    BitmapDescriptor markerIcon = await _getCustomMarkerIcon();
    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: location,
        infoWindow: const InfoWindow(title: 'Bus Location'),
        icon: markerIcon,
      ),
    );
    setState(() {}); // Refresh UI with the updated marker

    // Animate camera to the new bus location if the controller is initialized
    // if (_controller != null) {
    //   _animateToNewCurrentPosition(location, null);
    // }
  }

  // Update the user marker
  void _updateUserMarker(LatLng location) async {
    _markers.removeWhere(
        (marker) => marker.markerId == const MarkerId('current_location'));

    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: location,
        infoWindow: const InfoWindow(title: 'Current Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    setState(() {}); // Refresh UI with the updated marker

    // Animate camera to the user's new location if the controller is initialized
    // if (_controller != null) {
    //   _animateToNewCurrentPosition(location, null);
    // }
  }

  // Animate camera to the target position
  Future<void> _animateToNewCurrentPosition(
      LatLng targetPosition, double? zoomLevel) async {
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: targetPosition,
            zoom: zoomLevel ?? 18,
          ),
        ),
      );
    }
  }

  // Get custom bus marker icon from assets
  Future<BitmapDescriptor> _getCustomMarkerIcon() async {
    return await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(35, 35)),
      wellcomeScreenImage, // Ensure this asset path is correct
    );
  }

  Future<BitmapDescriptor> _getUserCustomMarkerIcon() async {
    return await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      locationIcon, // Ensure this asset path is correct
    );
  }

  // Set current user location marker
  Future<void> _setMyLocMarker() async {
    BitmapDescriptor markerIcon = await _getUserCustomMarkerIcon();
    if (currentLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: currentLocation!,
          infoWindow: const InfoWindow(title: 'Current Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      setState(() {}); // Update UI with the new marker
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        onPressed: () {
          if (currentLocation != null) {
            // Animate to the current user location
            _animateToNewCurrentPosition(
                LatLng(currentLocation!.latitude, currentLocation!.longitude),
                18);
            _setMyLocMarker(); // Set marker for current location
          }
        },
        child: const Icon(Icons.location_on),
      ),
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: true,
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                    markers: _markers,
                    mapType: _mapType,
                    initialCameraPosition:
                        CameraPosition(target: currentLocation!, zoom: 14.4746),
                    zoomControlsEnabled: false,
                    polylines: {
                      Polyline(
                          polylineId: const PolylineId('Route'),
                          points: polylineCoordinates)
                    },
                    onMapCreated: _onMapCreated),
                Positioned(
                  height: mediaQuery.height * 0.1,
                  right: mediaQuery.width * 0.1,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[600],
                    ),
                    child: IconButton(
                      onPressed: () {
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            mediaQuery.width * 0.9,
                            mediaQuery.height * 0.1,
                            mediaQuery.width * 0.2,
                            mediaQuery.height * 0.9,
                          ),
                          items: [
                            PopupMenuItem(
                              child: MapStyleTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _mapType = MapType.satellite;
                                  });
                                },
                                icon: const Icon(Icons.map_outlined),
                                text: 'SATELLITE',
                              ),
                            ),
                            PopupMenuItem(
                              child: MapStyleTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _mapType = MapType.normal;
                                  });
                                },
                                icon: const Icon(Icons.map_outlined),
                                text: 'NORMAL',
                              ),
                            ),
                            PopupMenuItem(
                              child: MapStyleTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _mapType = MapType.none;
                                  });
                                },
                                icon: const Icon(Icons.map_outlined),
                                text: 'NONE',
                              ),
                            ),
                          ],
                        );
                      },
                      icon: const Icon(Icons.map_outlined),
                    ),
                  ),
                ),
                Positioned(
                  bottom: mediaQuery.height * 0.11,
                  right: mediaQuery.width * 0.05,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (widget.locationEnable == true &&
                            _controller != null) {
                          _animateToNewCurrentPosition(busLoc, 18);
                        }
                      },
                      icon: const Icon(Icons.directions_bus),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
