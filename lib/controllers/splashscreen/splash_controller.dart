import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToInfoScreen();
  }

  void navigateToInfoScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed('/info');
  }
}
