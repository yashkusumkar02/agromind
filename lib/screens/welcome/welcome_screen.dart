import 'package:agromind/bindings/info_screen/info_binding.dart';
import 'package:agromind/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // Replace with your background image
              fit: BoxFit.cover,
            ),
          ),
          // Center Content with Rounded Rectangle
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
              height: MediaQuery.of(context).size.height * 0.5, // 60% of screen height
              decoration: BoxDecoration(
                color: Color(0xFFD9FFDF), // Light green color for the rectangle
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png', // Replace with your logo image
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  // Title
                  Text(
                    'Welcome Screen',
                    style: GoogleFonts.philosopher(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900], // Dark green for text
                    ),
                  ),
                  SizedBox(height: 40),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Register Button
                      OutlinedButton(
                        onPressed: () {
                          // Navigate to Register Screen
                          Get.toNamed('/register');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 12),
                          side: BorderSide(color: Colors.green[700]!), // Border color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                      // Login Button
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700], // Green background
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
