import 'package:get/get.dart';

import '../../controllers/PlantLibraryController/PlantLibraryController.dart';

class PlantLibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlantLibraryController>(() => PlantLibraryController());
  }
}
