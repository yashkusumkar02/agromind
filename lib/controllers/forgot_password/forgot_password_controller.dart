import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();

  void sendResetInstructions() {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email address",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Dummy email check (you can replace this with actual API logic)
    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Invalid Email", "Please enter a valid email",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // Simulate API request for password reset
    Get.snackbar("Success", "Password reset instructions sent to $email",
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}
