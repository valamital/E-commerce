import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  Future addRemoveCartItem(isAddedToCart) async{
    try {
      if (isAddedToCart) {
      controller
            .removeFromCart(
           model!.id ??
                0);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(
          const SnackBar(
            content: Text(
                "Item removed from cart"),
          ),
        );
      } else {
        await controller
            .addToCart(
           model!);
        controller
            .getCardList();
        var showSnackBar =
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(
          const SnackBar(
            content: Text(
                "Item added to cart"),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
