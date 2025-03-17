import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterVerifyAccountController extends GetxController {
  var isResendEnabled = false.obs;
  var countdown = 59.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    startCountdown();
  }

  /// **Starts Countdown for Resending Email**
  void startCountdown() async {
    while (countdown.value > 0) {
      await Future.delayed(Duration(seconds: 1));
      countdown.value--;
    }
    isResendEnabled.value = true;
  }

  /// **Checks if the User has Verified their Email**
  Future<void> checkEmailVerification() async {
    User? user = _auth.currentUser;
    await user?.reload(); // Refresh user state

    if (user != null && user.emailVerified) {
      Get.snackbar("Success", "Email Verified Successfully!");
      Get.offAllNamed('/login'); // ✅ Navigate to Login Screen
    } else {
      Get.snackbar("Error", "Email not verified. Please check your inbox.");
    }
  }

  /// **Sends Email Verification Link Again**
  Future<void> resendVerificationEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      isResendEnabled.value = false;
      countdown.value = 59;
      startCountdown();
      Get.snackbar("Success", "A new verification email has been sent.");
    } else {
      Get.snackbar("Error", "Your email is already verified.");
    }
  }
}
