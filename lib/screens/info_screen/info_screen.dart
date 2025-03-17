import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/info_screen/info_controller.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> with SingleTickerProviderStateMixin {
  final InfoController controller = Get.find();

  late AnimationController _animationController;
  late Animation<Offset> _rectangleAnimation;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize Animation Controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Rectangle Slide-In Animation
    _rectangleAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0), // Start from outside the left
      end: Offset.zero, // End at the original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Text Fade-In Animation
    _fadeInAnimation = Tween<double>(
      begin: 0.0, // Start invisible
      end: 1.0, // Fully visible
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Start Animations
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
          // Animated Rectangle
          SlideTransition(
            position: _rectangleAnimation,
            child: Align(
              alignment: Alignment.topLeft, // Align to the top-left
              child: Container(
                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05), // 5% padding from right
                width: MediaQuery.of(context).size.width * 0.9, // 90% width of the screen
                height: MediaQuery.of(context).size.height * 0.9, // 90% of the screen height
                decoration: BoxDecoration(
                  color: Color(0xFFD9FFDF), // Rectangle color set to D9FFDF
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(150), // Rounded bottom-right corner
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/images/logo.png', // Replace with your logo
                        height: 150,
                      ),
                      SizedBox(height: 20),
                      // Title with Fade-In Animation
                      FadeTransition(
                        opacity: _fadeInAnimation,
                        child: Text(
                          'AgroMind',
                          style: GoogleFonts.philosopher(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      // Description with Fade-In Animation
                      FadeTransition(
                        opacity: _fadeInAnimation,
                        child: Text(
                          'The AI-Driven Plant Health Advisor for Home Gardeners is an intelligent mobile application designed to help home gardeners monitor and maintain plant health using AI-powered diagnosis and personalized care recommendations. This app leverages machine learning, image processing, and AI-driven insights to detect plant diseases, provide treatment solutions, and guide users on optimal plant care.\n\nWith an intuitive Flutter-based UI, users can upload images of their plants, receive real-time disease detection results, and access a comprehensive plant care database. The app also includes a virtual AI assistant to answer gardening-related queries, offer plant care tips, and send reminders for watering, fertilization, and pruning.',
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.philosopher(
                            fontSize: 14,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      // Welcome Button
                      ElevatedButton(
                        onPressed: controller.navigateToWelcomeScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        child: Text(
                          'Welcome',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
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
