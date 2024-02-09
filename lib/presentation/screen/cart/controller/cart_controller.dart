import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dashboard/controller/home_page_controller.dart';
import '../../dashboard/models/item_model.dart';

class CartController extends GetxController {

  late final HomePageController homePageController;
  @override
  void onInit() {
    super.onInit();
    homePageController = Get.find<HomePageController>();
  }
  void removeFromCart(int shopId) {
    homePageController.removeFromCart(shopId);
  }

  String getItemTotal() {
    double sum = 0.0;
    String formattedSum = "0.0";
    for (var item in homePageController.cartItems ?? []) {
      // Ensure item.price is not null before adding
      if (item.price != null) {
        // Replace any non-numeric characters (except for the decimal point) and then parse
        sum += double.parse(
            item.price.toString().replaceAll(RegExp(r'[^\d.]'), ''));
        formattedSum = sum.toStringAsFixed(2);
      }
    }
    return formattedSum;
  }

  void showMessage(ShopItemModel shopItemModel) {
    removeFromCart(shopItemModel.shopId ?? 0);
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(content: Text("Item removed from cart successfully")),
    );
    update();
  }
}
