import 'package:get/get.dart';

import '../../controllers/info_screen/info_controller.dart';

class InfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InfoController());
  }
}
