import 'package:get/get.dart';

import '../controller/product_details_controller.dart';

class productDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductDetailController());
  }
}
