import 'package:get/get.dart';

class WelcomeController extends GetxController {
  void navigateToRegister() {
    Get.toNamed('/register');
  }

  void navigateToLogin() {
    Get.toNamed('/login');
  }
}
