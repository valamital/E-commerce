import 'package:get/get.dart';

import '../controller/home_page_controller.dart';

class homeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController());
  }
}
