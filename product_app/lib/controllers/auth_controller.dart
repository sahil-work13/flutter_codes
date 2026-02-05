import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../routes/app_routes.dart';
import '../services/session_services.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  Future<void> loginController(String email) async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    await SessionServices.saveUser(email);

    isLoading.value = false;

    Get.offAllNamed(AppRoutes.home); // ✅ FIXED
  }

  Future<void> logoutController() async {
    await SessionServices.logout();
    Get.offAllNamed(AppRoutes.login); // ✅ FIXED
  }
}
