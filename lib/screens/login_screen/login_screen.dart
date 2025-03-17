import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/login_screen/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
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

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          // 📝 Title
                          Center(
                            child: Text(
                              'Login',
                              style: GoogleFonts.philosopher(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),

                          // 📩 Email Field
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              labelStyle: GoogleFonts.poppins(color: Colors.white),
                              hintText: 'Enter your email',
                              hintStyle: GoogleFonts.poppins(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.transparent,
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
                          Obx(
                                () => TextField(
                              controller: passwordController,
                              obscureText: controller.isPasswordHidden.value,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: GoogleFonts.poppins(color: Colors.white),
                                hintText: 'Enter your password',
                                hintStyle: GoogleFonts.poppins(color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordHidden.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white70,
                                  ),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                              ),
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 🔑 Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed('/forgot-password');
                              },
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // ✅ Login Button
                          Center(
                            child: Obx(
                                  () => controller.isLoading.value
                                  ? CircularProgressIndicator()
                                  : OutlinedButton(
                                onPressed: () {
                                  controller.login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.white, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                                ),
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // 🔵 Or Login With
                          Center(
                            child: Text(
                              'or login with',
                              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 🔥 Google Login Button
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: () => controller.loginWithGoogle(),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              ),
                              icon: Image.asset(
                                'assets/images/google_icon.png',
                                height: 24,
                              ),
                              label: Text(
                                'Continue with Google',
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                // ✅ Footer
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/register');
                          },
                          child: Text("Don't have an Account? Register Here", style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                        Text(
                          'Copyright @AgroMind 2025',
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
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
