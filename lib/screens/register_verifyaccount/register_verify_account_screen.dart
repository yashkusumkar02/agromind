import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/register_verifyaccount_controller/register_verify_account_controller.dart';

class RegisterVerifyAccountScreen extends StatelessWidget {
  final RegisterVerifyAccountController controller = Get.put(RegisterVerifyAccountController());

  @override
  Widget build(BuildContext context) {
    String email = Get.arguments ?? "your@email.com"; // Email passed from the register screen

    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background Image
          Positioned.fill(
            child: Image.asset('assets/images/register_background.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔙 Back Button
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Get.toNamed('/welcome');
                              },
                            ),
                          ),
                          const SizedBox(height: 50),

                          // 📝 Title
                          Center(
                            child: Text(
                              'Verify Your Email',
                              style: GoogleFonts.philosopher(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 50),

                          // 📩 Email Verification Instructions
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'A verification email has been sent to ',
                              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: email,
                                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: '.\nClick the link in the email to verify your account.',
                                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // ✅ "I Verified My Email" Button
                          Center(
                            child: OutlinedButton(
                              onPressed: () => controller.checkEmailVerification(), // ✅ Check if email is verified
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                              ),
                              child: Text(
                                'I Verified My Email',
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 🔄 Resend Email Verification Section
                          Obx(() => Column(
                            children: [
                              TextButton(
                                onPressed: controller.isResendEnabled.value
                                    ? () => controller.resendVerificationEmail() // ✅ Resend verification email
                                    : null,
                                child: RichText(
                                  text: TextSpan(
                                    text: "Didn't receive an email? ",
                                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                                    children: [
                                      TextSpan(
                                        text: "Resend Email",
                                        style: GoogleFonts.poppins(
                                          color: controller.isResendEnabled.value ? Colors.white : Colors.white38,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                "Resend in 00:${controller.countdown}",
                                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          )),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),

                // ✅ Footer
                Column(
                  children: [
                    Center(
                      child: Text(
                        'Copyright @AgroMind 2025',
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
