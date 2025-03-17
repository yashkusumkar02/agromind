import 'package:get/get.dart';

class CustomDrawerController extends GetxController {
  var isDrawerOpen = false.obs;
  var userName = "Suyash P. Kusumkar".obs;
  var location = "📍 Pune, IND".obs;

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }
}
