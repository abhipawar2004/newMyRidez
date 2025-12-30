import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class DriverFoundScreen extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final String pickupAddress;
  final String dropoffAddress;
  final String vehicleName;
  final String vehiclePrice;
  final String paymentMethod;

  const DriverFoundScreen({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.vehicleName,
    required this.vehiclePrice,
    required this.paymentMethod,
  });

  @override
  State<DriverFoundScreen> createState() => _DriverFoundScreenState();
}

class _DriverFoundScreenState extends State<DriverFoundScreen>
    with SingleTickerProviderStateMixin {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Sample driver data
  final Map<String, dynamic> _driverInfo = {
    'name': 'Rajesh Kumar',
    'rating': 4.8,
    'totalRides': 1247,
    'carModel': 'Honda City',
    'carNumber': 'PB 10 AB 1234',
    'carColor': 'White',
    'phoneNumber': '+91 98765 43210',
  };

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

    // Initialize animation for success checkmark
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _setupMarkersAndRoute();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupMarkersAndRoute() {
    // Create markers for pickup and dropoff
    _markers = {
      Marker(
        markerId: const MarkerId('pickup'),
        position: widget.pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Pickup', snippet: widget.pickupAddress),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: widget.dropoffLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Dropoff',
          snippet: widget.dropoffAddress,
        ),
      ),
    };

    // Create polyline
    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [widget.pickupLocation, widget.dropoffLocation],
        color: Colors.white,
        width: 8,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    // Calculate bounds to show both markers
    double minLat =
        widget.pickupLocation.latitude < widget.dropoffLocation.latitude
        ? widget.pickupLocation.latitude
        : widget.dropoffLocation.latitude;
    double maxLat =
        widget.pickupLocation.latitude > widget.dropoffLocation.latitude
        ? widget.pickupLocation.latitude
        : widget.dropoffLocation.latitude;
    double minLng =
        widget.pickupLocation.longitude < widget.dropoffLocation.longitude
        ? widget.pickupLocation.longitude
        : widget.dropoffLocation.longitude;
    double maxLng =
        widget.pickupLocation.longitude > widget.dropoffLocation.longitude
        ? widget.pickupLocation.longitude
        : widget.dropoffLocation.longitude;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    });
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
              target: widget.pickupLocation,
              zoom: 14.0,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            style: _mapStyle,
          ),

          // Back button
          Positioned(
            top: 50.h,
            left: 16.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Driver found card - Fixed bottom sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 96, 10, 166),
                    Colors.black,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),

                  // Success animation
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 50.sp,
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Driver Found Text
                  Text(
                    'Driver Found!',
                    style: GoogleFonts.roboto(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    'Your ${widget.vehicleName} is on the way',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Driver info card
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        // Driver profile
                        Row(
                          children: [
                            // Driver avatar
                            CircleAvatar(
                              radius: 30.r,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 35.sp,
                                color: Colors.black,
                              ),
                            ),

                            SizedBox(width: 12.w),

                            // Driver details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _driverInfo['name'],
                                    style: GoogleFonts.roboto(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '${_driverInfo['rating']} (${_driverInfo['totalRides']} rides)',
                                        style: GoogleFonts.roboto(
                                          fontSize: 12.sp,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Call button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 24.sp,
                                ),
                                onPressed: () {
                                  // Handle call
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Calling ${_driverInfo['name']}...',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Car details
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _driverInfo['carModel'],
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    _driverInfo['carNumber'],
                                    style: GoogleFonts.roboto(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.directions_car,
                                size: 40.sp,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Ride details
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Payment method
                        Row(
                          children: [
                            Icon(
                              Icons.payment,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              widget.paymentMethod,
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        // Price
                        Text(
                          widget.vehiclePrice,
                          style: GoogleFonts.roboto(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Cancel ride button
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: Text(
                              'Cancel Ride?',
                              style: GoogleFonts.roboto(color: Colors.white),
                            ),
                            content: Text(
                              'Are you sure you want to cancel this ride?',
                              style: GoogleFonts.roboto(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'No',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Get.back();
                                  Get.back();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Ride cancelled'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                                child: Text(
                                  'Yes, Cancel',
                                  style: GoogleFonts.roboto(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        'Cancel Ride',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
