import 'package:e_commarce_app_demo/core/utiles/app_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utiles/custom_appbar.dart';
import '../../../core/utiles/image_constant.dart';
import '../dashboard/controller/home_page_controller.dart';
import '../dashboard/models/item_model.dart';
import 'controller/cart_controller.dart';
import 'controller/payment_controller.dart';

class CartPage extends StatelessWidget {
  final CartController _cartController = Get.find<CartController>();
  final PaymentController _paymentController = Get.find<PaymentController>();

  Map<String, dynamic>? paymentIntent;

  CartPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GetBuilder<HomePageController>(
          builder: (HomePageController controller) {
            return CommonAppBar(
              title: AppText.CART_TITLE,
              cartItemCount: controller.cartItems.length,
            );
          },
        ),
      ),
      body: GetBuilder<HomePageController>(
        builder: (_) {
          return Center(
            child: _cartController.homePageController.cartItems.isEmpty
                ? Container(
                    color: Colors.white,
                    child: Image.asset(
                      ImageConstant.emptyCart,
                      fit: BoxFit.cover,
                    ),
                  )
                : buildCartList(context),
          );
        },
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildCartList(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: GetBuilder<HomePageController>(
              builder: (_) {
                return ListView(
                  shrinkWrap: true,
                  children: _cartController.homePageController.cartItems
                          .map((item) => generateCart(context, item))
                          .toList() ??
                      [],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget generateCart(BuildContext context, ShopItemModel item) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade100, width: 1.0),
            top: BorderSide(color: Colors.grey.shade100, width: 1.0),
          ),
        ),
        height: 100.0,
        child: Row(
          children: <Widget>[
            buildItemImage(item),
            buildItemDetails(context, item),
          ],
        ),
      ),
    );
  }

  Widget buildItemImage(ShopItemModel item) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        // Use Column instead of Align
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 5.0)
                  ],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage(item.image ?? ImageConstant.emptyCart),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItemDetails(BuildContext context, ShopItemModel item) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildItemNameRow(item),
            const SizedBox(height: 5.0),
            Text("Price ${item.price.toString()}"),
          ],
        ),
      ),
    );
  }

  Widget buildItemNameRow(ShopItemModel item) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            item.name ?? "test",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0),
          ),
        ),
        buildDeleteIcon(item),
      ],
    );
  }

  Widget buildDeleteIcon(ShopItemModel item) {
    return Container(
      alignment: Alignment.bottomRight,
      child: InkResponse(
        onTap: () {
          showDeleteConfirmationDialog(item);
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog(ShopItemModel item) {
    Get.defaultDialog(
      title: AppText.CONFIERMATION_TITLE,
      middleText: AppText.CONFIERMATION_MSG,
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: const Text(
            AppText.CANCEL_TEXT,
          ),
        ),
        TextButton(
          onPressed: () {
            _cartController.showMessage(item);
            Get.back(); // Close the dialog after performing the delete action
          },
          child: const Text(
            AppText.DELETE_TEXT,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildCheckoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildTotalText() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: GetBuilder<CartController>(
        builder: (_) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              Text(
                _cartController.getItemTotal(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildCheckoutButton(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 50,
      color: Colors.white,
      child: ElevatedButton.icon(
        onPressed: () {
          _paymentController
              .makePayment(_cartController.getItemTotal().toString());
        },
        icon: const Icon(Icons.payment),
        label: Container(
          alignment: Alignment.center,
          height: 40,
          child: GetBuilder<CartController>(
            builder: (_) {
              return Text(
                "Pay \$${_cartController.getItemTotal()}",
                style: const TextStyle(fontSize: 18),
              );
            },
          ),
        ),
      ),
    );
  }
}
