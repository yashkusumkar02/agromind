import 'package:get/get.dart';

import '../../controllers/welcome_screen/welcome_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WelcomeController());
  }
}
