import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_app/screen/select_route.dart';
import 'package:ride_app/utils/constants.dart';
import '../../drawer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;
  double _sheetHeight = 0.35; // Initial sheet height (35% of screen)

  final LatLng _defaultCenter = const LatLng(37.7749, -122.4194);

  final String _mapStyle = '''[
    {
      "featureType": "poi",
      "stylers": [
        { "visibility": "on" }
      ]
    },
    {
      "featureType": "transit",
      "stylers": [
        { "visibility": "on" }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.icon",
      "stylers": [
        { "visibility": "on" }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        { "color": "#404040" }
      ]
    },
    {
      "featureType": "water",
      "stylers": [
        { "color": "#303030" }
      ]
    },
    {
      "featureType": "landscape",
      "stylers": [
        { "color": "#1a1a1a" }
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "labels",
      "stylers": [
        { "visibility": "off" }
      ]
    }
  ]''';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentPosition = _defaultCenter;
          _isLoading = false;
        });
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentPosition = _defaultCenter;
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentPosition = _defaultCenter;
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // Move camera to current location
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentPosition!, zoom: 17.0),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _currentPosition = _defaultCenter;
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // If location is already loaded, move camera to it
    if (_currentPosition != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 17.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: null,
      drawer: const AppDrawer(),
      backgroundColor: bg,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // MAP - takes remaining space after sheet
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: screenHeight * _sheetHeight,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition ?? _defaultCenter,
                      zoom: 25.0,
                    ),
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    buildingsEnabled: false,

                    style: _mapStyle,
                  ),
                ),

                // MENU BUTTON (TOP LEFT)
                Positioned(
                  top: 50,
                  left: 16,
                  child: Builder(
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ).withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ),
                ),

                // DRAGGABLE BOTTOM SHEET
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        // Update sheet height based on drag
                        _sheetHeight -= details.delta.dy / screenHeight;
                        // Clamp between 10% (minimized) and 60% (expanded)
                        _sheetHeight = _sheetHeight.clamp(0.1, 0.6);
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      height: screenHeight * _sheetHeight,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [const Color.fromARGB(255, 96, 10, 166)!, Colors.black],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        border: Border.all(color: Colors.white, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Drag handle
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),

                            // SEARCH BOX
                            InkWell(
                              onTap: () => Get.to(() => const RouteScreen()),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      size: 24,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Where to?",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            const Text(
                              "Recent locations",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _recentTile(
                              "Shaheed Bhagat Singh International Airport",
                              "Chandigarh Airport",
                            ),
                            _recentTile(
                              "Railway station, Near Ghanta Ghar, Jagraon bridge entry gate",
                              "Ludhiana Railway Station",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _recentTile(String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.access_time, color: Colors.white70),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white70),
      ),
      dense: true,
    );
  }
}
