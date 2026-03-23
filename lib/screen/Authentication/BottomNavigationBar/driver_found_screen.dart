import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:ride_app/core/theme/app_colors.dart';

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

  // Ride OTP for verification
  final String _rideOTP = '4582';

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
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Google Map (top half)
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
                      color: AppColors.cardBackground,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                        size: 24.sp,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.darkGradient,
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
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Column(
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

                      // Driver Found Text
                      Text(
                        'Driver Found!',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      // OTP Display Card
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: EdgeInsets.all(10.w),

                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  _rideOTP,
                                  style: GoogleFonts.roboto(
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 8.w,
                                  ),
                                ),
                              ],
                            ),

                            // OTP Number Display
                            SizedBox(height: 5.h),
                            Text(
                              'Share this OTP with your driver',
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Driver info card
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Driver profile
                            Row(
                              children: [
                                // Driver avatar
                                CircleAvatar(
                                  radius: 24.r,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    size: 28.sp,
                                    color: Colors.black,
                                  ),
                                ),

                                SizedBox(width: 10.w),

                                // Driver details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _driverInfo['name'],
                                        style: GoogleFonts.roboto(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 13.sp,
                                          ),
                                          SizedBox(width: 3.w),
                                          Text(
                                            '${_driverInfo['rating']} (${_driverInfo['totalRides']} rides)',
                                            style: GoogleFonts.roboto(
                                              fontSize: 10.sp,
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
                                    color: AppColors.successDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                    padding: EdgeInsets.all(8.w),
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      // Handle call
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Calling ${_driverInfo['name']}...',
                                          ),
                                          backgroundColor: AppColors.success,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10.h),

                            // Car details
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _driverInfo['carModel'],
                                            style: GoogleFonts.roboto(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            _driverInfo['carNumber'],
                                            style: GoogleFonts.roboto(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.directions_car,
                                        size: 30.sp,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                               
                                 
                                ],
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
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to cancel this ride?',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white70,
                                  ),
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Ride cancelled'),
                                          backgroundColor: AppColors.errorDark,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Yes, Cancel',
                                      style: GoogleFonts.roboto(
                                        color: AppColors.errorLight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.error, width: 2),
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
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 20.h,
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
}
