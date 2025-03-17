import 'package:get/get.dart';

import '../../controllers/plant_diagnosis_controller/plant_diagnosis_controller.dart';

class PlantDiagnosisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlantDiagnosisController>(() => PlantDiagnosisController());
  }
}
