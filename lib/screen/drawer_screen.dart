import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_app/core/theme/app_colors.dart';
import 'package:ride_app/screen/address_screen.dart';
import 'Authentication/BottomNavigationBar/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.darkGradient,
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  const SizedBox(height: 10),

                  _sectionTitle("Menu"),
                  _drawerTile(Icons.home_outlined, "Home", () {
                    Navigator.pop(context);
                  }),
                  _drawerTile(Icons.history_outlined, "My Rides History", () {
                    Navigator.pop(context);
                  }),
                  _drawerTile(
                    Icons.credit_card_outlined,
                    "Payment Methods",
                    () {
                      Navigator.pop(context);
                    },
                  ),
                  _drawerTile(Icons.person_outline, "Address", () {
                    Navigator.pop(context);
                    Get.to(() => const AddressScreen());
                  }),
                  const SizedBox(height: 10),
                  _sectionTitle("Legal & Others"),
                  _drawerTile(
                    Icons.privacy_tip_outlined,
                    "Privacy Policy",
                    () {},
                  ),
                  _drawerTile(
                    Icons.description_outlined,
                    "Terms & Conditions",
                    () {},
                  ),
                  const SizedBox(height: 10),
                  _logoutTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- UI Components --------------------
  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.zero,
        onTap: () {
          Navigator.pop(context);
          Get.to(() => const ProfileScreen());
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.black),
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Abhishek Pawar',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'View Profile',
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground.withOpacity(0.65),
          // borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: AppColors.border, width: 1),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Icon(icon, color: AppColors.textPrimary),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _logoutTile() {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground.withOpacity(0.65),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: ListTile(
          leading: Icon(Icons.logout, color: AppColors.errorLight),
          title: Text(
            "Logout",
            style: GoogleFonts.poppins(
              color: AppColors.errorLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
