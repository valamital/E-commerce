import 'package:e_commarce_app_demo/presentation/screen/cart/controller/payment_controller.dart';
import 'package:get/get.dart';

import '../controller/cart_controller.dart';


class paymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentController());
  }
}
