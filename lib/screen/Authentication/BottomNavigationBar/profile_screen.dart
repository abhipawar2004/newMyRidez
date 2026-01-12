import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_app/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class User {
  final String username;
  final String name;
  final String email;
  final String phone;
  final String address;

  User({required this.username, required this.name, required this.email, required this.phone, required this.address});
}

Widget _infoTile(IconData icon, String label, String value) {
  return ListTile(
    leading: Icon(icon, color: Colors.white70),
    title: Text(
      label,
      style: GoogleFonts.roboto(color: Colors.white70, fontSize: 12.sp),
    ),
    subtitle: Text(
      value.isNotEmpty ? value : '-',
      style: GoogleFonts.roboto(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
    dense: true,
  );
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUser();
  }

  Future<User> _loadUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return User(
      username: 'johndoe',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1 555-123-4567',
      address: '123 Main St, Springfield, USA',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Profile', style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 96, 10, 166), Colors.black, Colors.black],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                SizedBox(height: 20.h),
                FutureBuilder<User>(
                  future: _userFuture,
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    return Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40.r,
                              backgroundColor: Colors.white10,
                              child: Icon(
                                Icons.person,
                                size: 45.sp,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                  size: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          user?.name ?? 'Loading...',
                          style: GoogleFonts.roboto(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Info card
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          child: Card(
                            color: Colors.white10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Column(
                                children: [
                                  _infoTile(Icons.person_outline, 'Username', user?.username ?? ''),
                                  Divider(color: Colors.white24, height: 1.h),
                                  _infoTile(Icons.badge, 'Full name', user?.name ?? ''),
                                  Divider(color: Colors.white24, height: 1.h),
                                  _infoTile(Icons.email_outlined, 'Email', user?.email ?? ''),
                                  Divider(color: Colors.white24, height: 1.h),
                                  _infoTile(Icons.phone_outlined, 'Phone', user?.phone ?? ''),
                                  Divider(color: Colors.white24, height: 1.h),
                                  _infoTile(Icons.location_on_outlined, 'Address', user?.address ?? ''),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
    ), 
    ); 
  }
 



}
