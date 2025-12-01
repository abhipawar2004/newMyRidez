import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import 'Authentication/BottomNavigationBar/ride_booking_screen.dart';

class MapSelectionScreen extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final String pickupAddress;
  final String dropoffAddress;

  const MapSelectionScreen({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupAddress,
    required this.dropoffAddress,
  });

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? _mapController;
  late LatLng _currentDropoffPosition;

  @override
  void initState() {
    super.initState();
    _currentDropoffPosition = widget.dropoffLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Center on dropoff location only
    Future.delayed(const Duration(milliseconds: 300), () {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentDropoffPosition, zoom: 16.0),
        ),
      );
    });
  }

  void _onCameraMove(CameraPosition position) {
    // Update the dropoff position as the map moves
    setState(() {
      _currentDropoffPosition = position.target;
    });
    print('Camera moved to: ${position.target}');
  }

  void _onCameraIdle() {
    // Update state when camera stops moving
    setState(() {});
    print('Camera idle at: $_currentDropoffPosition');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentDropoffPosition,
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
          ),

          // Fixed center marker (not on map, but in center of screen)
          Center(
            child: Image.asset(
              'assets/images/markers.png',
              width: 48.w,
              height: 48.h,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to icon if image not found
                return Icon(Icons.location_on, size: 48.sp, color: c1);
              },
            ),
          ),

          // Confirm button at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Location info
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: c1, size: 20.sp),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Lat: ${_currentDropoffPosition.latitude.toStringAsFixed(6)}',
                                style: GoogleFonts.roboto(fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: c1, size: 20.sp),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Lng: ${_currentDropoffPosition.longitude.toStringAsFixed(6)}',
                                style: GoogleFonts.roboto(fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        // Debug: Print the coordinates CLEARLY
                        print('========================================');
                        print('SELECTED LOCATIONS:');
                        print(
                          'Pickup Location: ${widget.pickupLocation.latitude}, ${widget.pickupLocation.longitude}',
                        );
                        print(
                          'NEW Dropoff Location: ${_currentDropoffPosition.latitude}, ${_currentDropoffPosition.longitude}',
                        );
                        print('========================================');

                        // Navigate to ride booking screen with UPDATED dropoff location
                        Get.to(
                          () => RideBookingScreen(
                            pickupLocation: widget.pickupLocation,
                            dropoffLocation:
                                _currentDropoffPosition, // Use the updated position from map
                            pickupAddress: widget.pickupAddress,
                            dropoffAddress:
                                'Selected Location: ${_currentDropoffPosition.latitude.toStringAsFixed(4)}, ${_currentDropoffPosition.longitude.toStringAsFixed(4)}',
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Confirm & Find Driver',
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // My Location button
          Positioned(
            bottom: 200.h,
            right: 16.w,
            child: FloatingActionButton(
              onPressed: () {
                if (_mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: _currentDropoffPosition,
                        zoom: 16.0,
                      ),
                    ),
                  );
                }
              },
              backgroundColor: Colors.white,
              mini: true,
              child: Icon(Icons.my_location, color: c1),
            ),
          ),
        ],
      ),
    );
  }
}
