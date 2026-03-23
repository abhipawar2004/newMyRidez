import 'package:flutter/material.dart';
import 'package:ride_app/screen/Authentication/register.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_app/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'My Ride App',
          theme: AppTheme.lightTheme,
          home: const PhoneSignInScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
