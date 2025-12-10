import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import 'map_selection_screen.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();

  // Static coordinates for testing
  final LatLng _pickupLatLng = const LatLng(30.7333, 76.7794); // Chandigarh
  final LatLng _dropoffLatLng = const LatLng(30.9010, 75.8573); // Ludhiana
  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _dropoffFocusNode = FocusNode();

  bool _isPickupFocused = false;
  bool _isDropoffFocused = false;

  @override
  void initState() {
    super.initState();
    _pickupFocusNode.addListener(() {
      setState(() {
        _isPickupFocused = _pickupFocusNode.hasFocus;
      });
    });
    _dropoffFocusNode.addListener(() {
      setState(() {
        _isDropoffFocused = _dropoffFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    _pickupFocusNode.dispose();
    _dropoffFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white, size: 28.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Your route',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // Route input fields
          Container(
            decoration: BoxDecoration(
              color: bg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10.0.w, top: 10.h, bottom: 13.h),
              child: Container(
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _isPickupFocused
                                    ? Colors.white
                                    : Colors.grey,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 11.w,
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _pickupController,
                                    focusNode: _pickupFocusNode,
                                    decoration: InputDecoration(
                                      hintText: 'Pickup location',
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 9.h,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // Dropoff location field with swap button in row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _isDropoffFocused
                                    ? Colors.white
                                    : Colors.grey,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                  ),
                                  child: Icon(
                                    Icons.circle_outlined,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _dropoffController,
                                    focusNode: _dropoffFocusNode,
                                    decoration: InputDecoration(
                                      hintText: 'Dropoff location',
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 9.h,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.swap_vert,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          onPressed: () {
                            // Swap pickup and dropoff
                            final temp = _pickupController.text;
                            _pickupController.text = _dropoffController.text;
                            _dropoffController.text = temp;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Current location option
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            child: ListTile(
              leading: Icon(
                Icons.my_location,
                color: Colors.black87,
                size: 24.sp,
              ),
              title: Text(
                'Current location',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                _pickupController.text = 'Current location';
              },
            ),
          ),
          const Spacer(),
          // Find Driver button
          Padding(
            padding: EdgeInsets.all(16.0.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to map selection screen with static coordinates
                  Get.to(
                    () => MapSelectionScreen(
                      pickupLocation: _pickupLatLng,
                      dropoffLocation: _dropoffLatLng,
                      pickupAddress: _pickupController.text.isEmpty
                          ? 'Chandigarh, India'
                          : _pickupController.text,
                      dropoffAddress: _dropoffController.text.isEmpty
                          ? 'Ludhiana, India'
                          : _dropoffController.text,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: bg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Find Driver',
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
