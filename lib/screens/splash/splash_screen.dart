import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
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
          // Center Content with Rectangle
          Align(
            alignment: Alignment.bottomCenter, // Align rectangle to the bottom
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Full screen width
              height: MediaQuery.of(context).size.height * 0.6, // 60% of the screen height
              decoration: BoxDecoration(
                color: Color(0xFFD9FFDF), // Light green color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(150), // Rounded top-left corner
                  topRight: Radius.circular(150), // Rounded top-right corner
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png', // Replace with your logo image
                    height: 150,
                  ),
                  SizedBox(height: 20),
                  // App Name
                  Text(
                    'AgroMind',
                    style: GoogleFonts.philosopher(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900], // Dark green for text
                    ),
                  ),
                  // Underline
                  SizedBox(height: 5),
                  Container(
                    height: 2, // Thickness of the line
                    width: 100, // Length of the line
                    color: Colors.green[700], // Color of the line
                  ),
                  SizedBox(height: 10),
                  // Tagline
                  Text(
                    'AI-driven plant health advisor',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontStyle: FontStyle.italic, // Set text to italic
                      color: Colors.green[700], // Softer green for tagline
                    ),
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
