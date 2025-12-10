import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_app/utils/constants.dart';
import 'Authentication/BottomNavigationBar/account_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),

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
                _drawerTile(Icons.credit_card_outlined, "Payment Methods", () {
                  Navigator.pop(context);
                }),
                _drawerTile(Icons.person_outline, "Account", () {
                  Navigator.pop(context);
                  Get.to(() => const ProfileScreen());
                }),

                const SizedBox(height: 10),

                _sectionTitle("Legal & Others"),
                _drawerTile(Icons.settings_outlined, "Settings", () {}),
                _drawerTile(Icons.privacy_tip_outlined, "Privacy Policy", () {}),
                _drawerTile(Icons.description_outlined, "Terms & Conditions", () {}),

                const SizedBox(height: 10),

                _logoutTile(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- UI Components --------------------

  Widget _buildHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bg, bg.withOpacity(.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: bg),
            ),
            const SizedBox(width: 15),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Abhishek Pawar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'View Profile',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          color: Colors.white,
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
          gradient: LinearGradient(
            colors: [bg.withOpacity(0.9), bg.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: const TextStyle(fontSize: 15, color: Colors.white)),
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
          gradient: LinearGradient(
            colors: [bg.withOpacity(0.9), bg.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: const Icon(Icons.logout, color: Colors.white),
          title: const Text(
            "Logout",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
