import 'package:get/get.dart';
import '../../controllers/register_verifyaccount_controller/register_verify_account_controller.dart';

class RegisterVerifyAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterVerifyAccountController>(() => RegisterVerifyAccountController());
  }
}
