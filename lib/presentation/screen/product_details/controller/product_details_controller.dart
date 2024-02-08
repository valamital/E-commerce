import 'package:get/get.dart';
import '../../dashboard/controller/home_page_controller.dart';
import '../../dashboard/models/item_model.dart';

class ProductDetailController extends GetxController {
  int active = 0;

  HomePageController controller = Get.find<HomePageController>();

  RxInt itemId = 0.obs;
  ShopItemModel? model;

  @override
  void onInit() {
    super.onInit();

    itemId.value = Get.arguments['itemId'];
    model = controller.getItem(itemId.value);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
