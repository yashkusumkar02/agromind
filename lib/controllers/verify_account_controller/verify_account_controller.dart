import 'package:get/get.dart';

class VerifyAccountController extends GetxController {
  var isResendEnabled = false.obs;
  var countdown = 59.obs;

  @override
  void onInit() {
    startCountdown();
    super.onInit();
  }

  void startCountdown() async {
    while (countdown.value > 0) {
      await Future.delayed(Duration(seconds: 1));
      countdown.value--;
    }
    isResendEnabled.value = true;
  }

  void resendCode() {
    if (isResendEnabled.value) {
      countdown.value = 59;
      isResendEnabled.value = false;
      startCountdown();
      Get.snackbar("Success", "A new verification code has been sent!",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void verifyAccount(String code) {
    if (code.length == 4) {
      // ✅ Implement your verification logic
      if (code == "1234") { // Simulated Correct OTP (Replace with actual logic)
        Get.snackbar("Success", "Account Verified Successfully!",
            snackPosition: SnackPosition.BOTTOM);

        // ✅ Navigate to New Password Screen
        Get.toNamed('/new-password');
      } else {
        Get.snackbar("Error", "Invalid Code. Please try again.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar("Error", "Enter a valid 4-digit code.");
    }
  }
}
