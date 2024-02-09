import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utiles/app_text.dart';
import '../../../core/utiles/custom_appbar.dart';
import '../../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../dashboard/controller/home_page_controller.dart';
import 'controller/product_details_controller.dart';

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({super.key});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int active = 0;
  ProductDetailController controller2 = Get.find<ProductDetailController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GetBuilder<HomePageController>(
          builder: (HomePageController controller) {return CommonAppBar(
            title: AppText.PRODUCT_DETAILS_TITLE,
            onCartTap: () {
              Get.toNamed(AppRoutes.cartPage);
            },
            cartItemCount: controller.cartItems.length,
          );  },

        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
        ),
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 280.0,
                  padding: EdgeInsets.only(top: 10.0),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          controller2.model!.image ?? "",
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
                GetBuilder<HomePageController>(builder: (_) {
                  bool isAddedToCart = controller2.controller
                      .isAlreadyInCart(controller2.model!.id);

                  return Container(
                    height: 270.0,
                    alignment: Alignment(1.0, 1.0),
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: CustomButton(
                                  name: isAddedToCart
                                      ? "REMOVE CART"
                                      : "ADD TO CART",
                                  onTap: controller2.controller.isLoading
                                      ? null
                                      : () async {
                                    controller2.addRemoveCartItem(isAddedToCart);
                                        },
                                  icon: isAddedToCart
                                      ? const Icon(Icons.remove_shopping_cart)
                                      : const Icon(Icons.add_shopping_cart),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })
              ],
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[200]!, Colors.purple[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    // Increase the blur radius for a more pronounced shadow
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller2.model!.name ?? "kk",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22.0,
                          color: Colors.white, // Text color changed to white
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Reduced the space between name and price
                  Text(
                    "Price: \$${controller2.model!.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white70, // Adjusted text color for price
                    ),
                  ),

                  // You can add more widgets or customize as needed
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
