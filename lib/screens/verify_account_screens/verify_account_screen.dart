import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/verify_account_controller/verify_account_controller.dart';

class VerifyAccountScreen extends StatelessWidget {
  final VerifyAccountController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          // Title
                          Center(
                            child: Text(
                              'Verify Account',
                              style: GoogleFonts.philosopher(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          // Description
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Code has been sent to ',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'johndoe@gmail.com',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  '.\nEnter the code to verify your account.',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // OTP Input Field
                          TextField(
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter Code',
                              labelStyle:
                              GoogleFonts.poppins(color: Colors.white),
                              hintText: '4 Digit Code',
                              hintStyle:
                              GoogleFonts.poppins(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.transparent,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.green, width: 2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            style: GoogleFonts.poppins(color: Colors.white),
                            onChanged: (value) {
                              if (value.length == 4) {
                                controller.verifyAccount(value);
                              }
                            },
                          ),
                          const SizedBox(height: 10),

                          // Resend Code Section
                          Obx(() => Column(
                            children: [
                              TextButton(
                                onPressed: controller.isResendEnabled.value
                                    ? controller.resendCode
                                    : null,
                                child: RichText(
                                  text: TextSpan(
                                    text: "Didn't Receive Code? ",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Resend Code",
                                        style: GoogleFonts.poppins(
                                          color: controller
                                              .isResendEnabled.value
                                              ? Colors.white
                                              : Colors.white38,
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                          TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                "Resend code in 00:${controller.countdown}",
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )),
                          const SizedBox(height: 30),

                          // Verify Account Button
                          Center(
                            child: OutlinedButton(
                              onPressed: () {
                                // ✅ Call the controller to verify the code
                                controller.verifyAccount("1234"); // Replace with actual user input
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                              ),
                              child: Text(
                                'Verify Account',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Footer
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Footer Divider
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Divider(
                            color: Colors.white70,
                            thickness: 1.5,
                          ),
                        ),
                        // Copyright Text
                        Center(
                          child: Text(
                            'Copyright @AgroMind 2025',
                            style: GoogleFonts.poppins(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
