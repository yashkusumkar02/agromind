import 'package:get/get.dart';
import '../../controllers/drawer_controller/drawer_controller.dart';

class DrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomDrawerController>(() => CustomDrawerController());
  }
}
