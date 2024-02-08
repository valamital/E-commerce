import 'package:e_commarce_app_demo/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAndToNamed(AppRoutes.homePage);
    });
  }
}
