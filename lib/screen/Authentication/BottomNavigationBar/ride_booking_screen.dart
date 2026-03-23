import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:ride_app/core/theme/app_colors.dart';
import 'driver_found_screen.dart';

class RideBookingScreen extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final String pickupAddress;
  final String dropoffAddress;

  const RideBookingScreen({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupAddress,
    required this.dropoffAddress,
  });

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen>
    with SingleTickerProviderStateMixin {
  // Payment methods for dropdrawer
  final List<String> _paymentMethods = [
    'Cash',
    'UPI',
    'Card',
    'Wallet',
    'Net-Banking',
  ];

  String _selectedPaymentMethod = 'Cash';

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  final Set<Circle> _circles = {};

  int? _selectedVehicleIndex;
  bool _isSearchingDriver = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

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

  // Sample vehicle data
  final List<Map<String, dynamic>> _vehicles = [
    {
      'name': 'Mini',
      'type': 'Affordable, compact rides',
      'passengers': 4,
      'eta': '2 min',
      'price': '₹500.34',
      'icon': Icons.directions_car,
    },
    {
      'name': 'Sedan',
      'type': 'Comfortable sedans',
      'passengers': 6,
      'eta': '3 min',
      'price': '₹700.20',
      'icon': Icons.local_taxi,
    },
    {
      'name': 'Premier',
      'type': 'Premium sedans',
      'passengers': 6,
      'eta': '5 min',
      'price': '₹900.79',
      'icon': Icons.car_rental,
    },
    {
      'name': 'Truck',
      'type': 'SUVs for 6 people',
      'passengers': 12,
      'eta': '4 min',
      'price': '₹1000.00',
      'icon': Icons.airport_shuttle,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Listen to animation updates to rebuild circles
    _animationController.addListener(() {
      if (_isSearchingDriver) {
        _updateSearchingCircles();
      }
    });

    _setupMarkersAndRoute();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateSearchingCircles() {
    setState(() {
      _circles.clear();

      // Create 3 ripple circles at different stages
      for (int i = 0; i < 3; i++) {
        final double progress = (_animation.value + (i * 0.33)) % 1.0;
        final double radius = progress * 200; // meters
        final double opacity = 1.0 - progress;

        _circles.add(
          Circle(
            circleId: CircleId('ripple_$i'),
            center: widget.pickupLocation,
            radius: radius,
            strokeColor: AppColors.mapPrimary.withOpacity(opacity * 0.6),
            strokeWidth: 3,
            fillColor: AppColors.mapPrimary.withOpacity(opacity * 0.1),
          ),
        );
      }

      // Add a small pulsing circle at the center
      final double pulseOpacity = 0.6 + (_animation.value * 0.4);
      _circles.add(
        Circle(
          circleId: const CircleId('pulse_center'),
          center: widget.pickupLocation,
          radius: 15, // small radius in meters
          strokeColor: AppColors.mapMarker.withOpacity(pulseOpacity),
          strokeWidth: 4,
          fillColor: AppColors.mapMarker.withOpacity(pulseOpacity * 0.5),
        ),
      );
    });
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

    // Create a simple straight line polyline (white color)
    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [widget.pickupLocation, widget.dropoffLocation],
        color: AppColors.mapRoute,
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

    // Animate camera to show both locations with padding
    Future.delayed(const Duration(milliseconds: 500), () {
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    });
  }

  void _showDriverSearchingDialog() {
    // Start the ripple animation
    _animationController.repeat();

    // After 3 seconds, navigate to driver found screen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _animationController.stop();
        Get.off(
          () => DriverFoundScreen(
            pickupLocation: widget.pickupLocation,
            dropoffLocation: widget.dropoffLocation,
            pickupAddress: widget.pickupAddress,
            dropoffAddress: widget.dropoffAddress,
            vehicleName: _vehicles[_selectedVehicleIndex!]['name'],
            vehiclePrice: _vehicles[_selectedVehicleIndex!]['price'],
            paymentMethod: _selectedPaymentMethod,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map with markers and route
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.pickupLocation,
              zoom: 14.0,
            ),
            markers: _markers,
            polylines: _polylines,
            circles: _circles,
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

          // Bottom sheet with vehicle options
          DraggableScrollableSheet(
            initialChildSize: _isSearchingDriver ? 0.25 : 0.4,
            minChildSize: _isSearchingDriver ? 0.2 : 0.3,
            maxChildSize: _isSearchingDriver ? 0.3 : 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  gradient: AppColors.darkGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: _isSearchingDriver
                    ? _buildSearchingContent()
                    : _buildVehicleSelection(scrollController),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchingContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loading indicator
          SizedBox(
            width: 60.w,
            height: 60.h,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),

          SizedBox(height: 24.h),

          // Searching text
          Text(
            'Searching for drivers...',
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            'Please wait',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSelection(ScrollController scrollController) {
    return Column(
      children: [
        // Drag handle
        Container(
          width: 40.w,
          height: 4.h,
          margin: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.textDisabled,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),

        // Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Choose a ride',
                style: GoogleFonts.poppins(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Icon(
                Icons.info_outline,
                size: 20.sp,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Vehicle list
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: _vehicles.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (context, index) {
              final vehicle = _vehicles[index];
              final isSelected = _selectedVehicleIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedVehicleIndex = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.cardBackground
                        : AppColors.cardBackground.withOpacity(0.5),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      // Vehicle icon
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          vehicle['icon'],
                          size: 32.sp,
                          color: AppColors.primary,
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // Vehicle details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  vehicle['name'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.person,
                                  size: 14.sp,
                                  color: Colors.white70,
                                ),
                                Text(
                                  '${vehicle['passengers']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              vehicle['type'],
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${vehicle['eta']} away',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Price
                      Text(
                        vehicle['price'],
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Confirm button
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Dropdrawer-style payment method selector
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPaymentMethod,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textPrimary,
                      size: 20.sp,
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: AppColors.textPrimary,
                    ),
                    dropdownColor: AppColors.cardBackground,
                    items: _paymentMethods.map((method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(
                          method,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: SizedBox(
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _selectedVehicleIndex == null
                        ? null
                        : () {
                            setState(() {
                              _isSearchingDriver = true;
                            });
                            _showDriverSearchingDialog();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedVehicleIndex == null
                          ? AppColors.textDisabled
                          : AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _selectedVehicleIndex == null
                          ? 'Select a vehicle'
                          : 'Confirm ${_vehicles[_selectedVehicleIndex!]['name']}',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
