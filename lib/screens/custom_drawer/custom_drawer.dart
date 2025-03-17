import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controllers/home_controller/home_controller.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onClose; // Function to close the drawer
  final HomeController controller = Get.find(); // GetX Controller
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth Instance

  CustomDrawer({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270, // Drawer width
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9), // Semi-transparent dark background
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 50),

          // ✅ Profile Section
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
          ),
          const SizedBox(height: 10),
          Obx(() => Text(
            controller.userName.value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          )),
          Obx(() => Text(
            controller.location.value,
            style: TextStyle(fontSize: 14, color: Colors.white70),
          )),
          const SizedBox(height: 30),

          // ✅ Drawer Menu Items
          _buildDrawerItem("assets/icons/home.png", "Home", "/home"),
          _buildDrawerItem("assets/icons/plant_d.png", "Plant Diagnosis", "/plantDiagnosis"),
          _buildDrawerItem("assets/icons/garden.png", "My Garden", "/mygarden"),
          _buildDrawerItem("assets/icons/book.png", "Plant Library", "/plant_library"),
          _buildDrawerItem("assets/icons/bot.png", "Plant Health Advisor", "/plant-health-advisor"),
          _buildDrawerItem("assets/icons/community.png", "Community", "/community"),
          _buildDrawerItem("assets/icons/settings.png", "Settings", "/profile"),
          _buildDrawerItem("assets/icons/logout.png", "Logout", "/logout", isLogout: true),

          const Spacer(), // Pushes logout button to bottom
        ],
      ),
    );
  }

  // ✅ Drawer Item Builder (Fixed Navigation)
  Widget _buildDrawerItem(String iconPath, String title, String route, {bool isLogout = false}) {
    return GestureDetector(
      onTap: () {
        onClose(); // Close the drawer before navigating
        Future.delayed(Duration(milliseconds: 300), () {
          if (isLogout) {
            Get.defaultDialog(
              title: "Logout",
              middleText: "Are you sure you want to logout?",
              textConfirm: "Yes",
              textCancel: "No",
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              onConfirm: () async {
                await _logoutUser(); // Call Firebase Logout Function
              },
            );
          } else {
            Get.toNamed(route); // ✅ Navigate to required page
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Image.asset(iconPath, height: 24, width: 24),
            const SizedBox(width: 20),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // ✅ Firebase Logout Function
  Future<void> _logoutUser() async {
    try {
      await _auth.signOut(); // Firebase Sign Out
      Get.offAllNamed('/login'); // ✅ Navigate to Login Screen
    } catch (e) {
      Get.snackbar("Error", "Failed to log out. Please try again.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
