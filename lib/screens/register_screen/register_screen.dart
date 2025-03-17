import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/register_controller/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                        const SizedBox(height: 20),

                        // 📝 Title
                        Center(
                          child: Text(
                            'Register',
                            style: GoogleFonts.philosopher(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 50),

                        // 📌 First Name and Last Name Fields
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: firstNameController,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 📩 Email Field
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            labelStyle: GoogleFonts.poppins(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          style: GoogleFonts.poppins(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // 🔒 Password Field
                        Obx(() => TextField(
                          controller: passwordController,
                          obscureText: controller.isPasswordHidden.value,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: GoogleFonts.poppins(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(controller.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                          style: GoogleFonts.poppins(color: Colors.white),
                        )),
                        const SizedBox(height: 10),

                        // ✅ Confirm Password Field
                        Obx(() => TextField(
                          controller: confirmPasswordController,
                          obscureText: controller.isConfirmPasswordHidden.value,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: GoogleFonts.poppins(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(controller.isConfirmPasswordHidden.value ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                              onPressed: controller.toggleConfirmPasswordVisibility,
                            ),
                          ),
                          style: GoogleFonts.poppins(color: Colors.white),
                        )),
                        const SizedBox(height: 50),

                        // ✅ Create Account Button (Your UI remains the same)
                        Center(
                          child: Obx(() => controller.isLoading.value
                              ? CircularProgressIndicator()
                              : OutlinedButton(
                            onPressed: () {
                              controller.registerUser(
                                firstNameController.text,
                                lastNameController.text,
                                emailController.text,
                                passwordController.text,
                                confirmPasswordController.text,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                            ),
                            child: Text(
                              'Create Account',
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )),
                        ),

                        const SizedBox(height: 50),

                        // ✅ Terms and Privacy Policy
                        Center(
                          child: Text(
                            'By continuing, you agree to our Terms of Service and Privacy Policy.',
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // ✅ Footer (Bottom Aligned)
                Column(
                  children: [
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed('/login');
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an Account? ",
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Login",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Divider(
                        color: Colors.white70,
                        thickness: 1.5,
                      ),
                    ),
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
