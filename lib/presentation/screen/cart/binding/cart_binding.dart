import 'package:get/get.dart';

import '../controller/cart_controller.dart';


class cartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CartController());
  }
}
