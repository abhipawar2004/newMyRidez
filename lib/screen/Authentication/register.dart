import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';
import 'package:ride_app/screen/Authentication/BottomNavigationBar/home_screen.dart';
import 'package:ride_app/screen/basescreen.dart';
import 'package:ride_app/utils/constants.dart';

class PhoneSignInScreen extends StatefulWidget {
  const PhoneSignInScreen({super.key});

  @override
  State<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  late Country selectedCountry;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    selectedCountry = Country(
      countryCode: 'IN',
      name: 'India',
      phoneCode: '91',
      e164Sc: 0,
      geographic: true,
      level: 1,
      example: '9876543210',
      displayName: 'India (IN) [+91]',
      displayNameNoCountryCode: 'India (IN)',
      e164Key: '91-IN-0',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),

                /// TITLE
                Text(
                  "Verify your number",
                  style: TextStyle(
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Enter your mobile number to continue",
                  style: TextStyle(fontSize: 11.sp, color: Colors.white54),
                ),

                SizedBox(height: 40.h),

                /// PHONE INPUT
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: true,
                            onSelect: (country) {
                              setState(() => selectedCountry = country);
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              selectedCountry.flagEmoji,
                              style: TextStyle(fontSize: 20.sp),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "+${selectedCountry.phoneCode}",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          ],
                        ),
                      ),

                      SizedBox(width: 10.w),

                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontSize: 18.sp),
                          decoration: InputDecoration(
                            hintText: "Phone number",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.sp,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                /// TERMS (with checkbox)
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _agreed,
                        activeColor: const Color(0xFF0D63C7),
                        onChanged: (value) {
                          setState(() {
                            _agreed = value ?? false;
                          });
                        },
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          "By continuing, you agree to our Terms & Privacy Policy.",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// SIGN IN BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _agreed
                        ? () {
                            Get.to(() => const HomeScreen());
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D63C7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                      elevation: 6,
                      shadowColor: Colors.black26,
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 28.h),

                /// DIVIDER
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white70)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        "OR",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white70)),
                  ],
                ),

                SizedBox(height: 25.h),

                /// GOOGLE SIGN-IN
                _socialButton(
                  icon:
                      "https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png",
                  text: "Continue with Google",
                ),

                SizedBox(height: 16.h),

                /// FACEBOOK
                _socialButton(
                  icon:
                      "https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png",
                  text: "Continue with Facebook",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  /// SOCIAL BUTTON WIDGET
  Widget _socialButton({required String icon, required String text}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white70),
      ),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          side: BorderSide.none,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(icon, height: 22.h),
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
