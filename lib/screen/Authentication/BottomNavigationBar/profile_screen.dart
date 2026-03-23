import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_app/core/theme/app_colors.dart';

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

  User({
    required this.username,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });
}

Widget _infoTile(IconData icon, String label, String value) {
  return ListTile(
    leading: Icon(icon, color: AppColors.textSecondary),
    title: Text(
      label,
      style: GoogleFonts.poppins(
        color: AppColors.textSecondary,
        fontSize: 12.sp,
      ),
    ),
    subtitle: Text(
      value.isNotEmpty ? value : '-',
      style: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
    dense: true,
  );
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _userFuture;
  String _userStatus = 'online'; // online, offline, busy

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
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.scaffoldBackground,
            ],
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
                              backgroundColor: AppColors.cardBackground,
                              child: Icon(
                                Icons.person,
                                size: 45.sp,
                                color: AppColors.primary,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.cardBackground,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 16.w,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  color: _userStatus == 'online'
                                      ? AppColors.online
                                      : _userStatus == 'busy'
                                      ? AppColors.busy
                                      : AppColors.offline,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.scaffoldBackground,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          user?.name ?? 'Loading...',
                          style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _userStatus == 'online'
                              ? 'Online'
                              : _userStatus == 'busy'
                              ? 'Busy'
                              : 'Offline',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: _userStatus == 'online'
                                ? AppColors.online
                                : _userStatus == 'busy'
                                ? AppColors.busy
                                : AppColors.offline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Info card
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          child: Card(
                            color: AppColors.cardBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Column(
                                children: [
                                  _infoTile(
                                    Icons.person_outline,
                                    'Username',
                                    user?.username ?? '',
                                  ),
                                  Divider(
                                    color: AppColors.divider,
                                    height: 1.h,
                                  ),
                                  _infoTile(
                                    Icons.badge,
                                    'Full name',
                                    user?.name ?? '',
                                  ),
                                  Divider(
                                    color: AppColors.divider,
                                    height: 1.h,
                                  ),
                                  _infoTile(
                                    Icons.email_outlined,
                                    'Email',
                                    user?.email ?? '',
                                  ),
                                  Divider(
                                    color: AppColors.divider,
                                    height: 1.h,
                                  ),
                                  _infoTile(
                                    Icons.phone_outlined,
                                    'Phone',
                                    user?.phone ?? '',
                                  ),
                                  Divider(
                                    color: AppColors.divider,
                                    height: 1.h,
                                  ),
                                  _infoTile(
                                    Icons.location_on_outlined,
                                    'Address',
                                    user?.address ?? '',
                                  ),
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
