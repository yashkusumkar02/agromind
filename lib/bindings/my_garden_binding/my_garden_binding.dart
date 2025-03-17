import 'package:get/get.dart';
import '../../controllers/my_garden_controller/my_garden_controller.dart';

class MyGardenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyGardenController>(() => MyGardenController());
  }
}
