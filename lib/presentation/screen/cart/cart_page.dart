import 'package:dio/dio.dart';
import 'package:e_commarce_app_demo/core/utiles/app_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import '../../../core/utiles/api_constant.dart';
import '../../../core/utiles/custom_appbar.dart';
import '../../../core/utiles/image_constant.dart';
import '../dashboard/controller/home_page_controller.dart';
import '../dashboard/models/item_model.dart';
import 'controller/cart_controller.dart';

class CartPage extends StatelessWidget {
  final CartController _cartController = Get.find<CartController>();
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
      child: Column( // Use Column instead of Align
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5.0)],
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
          makePayment(_cartController.getItemTotal().toString());
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

  Future<void> makePayment(String total) async {
    try {
      paymentIntent = await createPaymentIntent(total, 'USD');

      if (paymentIntent != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            style: ThemeMode.light,
            customFlow: true,
            allowsDelayedPaymentMethods: true,
            merchantDisplayName: 'mital',
          ),
        );

        await displayPaymentSheet();
      } else {}
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }
    }
  }

  Future<void> displayPaymentSheet() async {
    BuildContext? context = Get.context;

    if (context == null) {
      return;
    }

    try {
      var paymentResult = await Stripe.instance.presentPaymentSheet();

      _showSuccessDialog();

      paymentIntent = null;
    } on StripeException catch (e) {
      if (kDebugMode) {
        print("Stripe Exception: $e");
      }
      _showErrorDialog("Payment Failed", "Error: $e");
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Unhandled Exception: $e");
      }
      if (kDebugMode) {
        print(stackTrace);
      }
      _showErrorDialog("Payment Failed", "Unhandled Error: $e");
    }
  }

  void _showErrorDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: const Text(
              AppText.OK_TEXT,
              style: TextStyle(
                color: Colors.red,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              AppText.PAYMENT_SUCCESS_MSG,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog using GetX
            },
            child: const Text(
              AppText.OK_TEXT,
              style: TextStyle(
                color: Colors.green,
                fontSize: 19.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? "";
    String authorizationHeader = 'Bearer $stripeSecretKey';

    try {
      // Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      Dio dio = Dio();

      var response = await dio.post(
        ApiConstant.STRIPE_API,
        options: Options(
          headers: {
            'Authorization': authorizationHeader,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'Failed to create payment intent. Status Code: ${response.statusCode}',
        );
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmount = (double.parse(amount) * 100).toStringAsFixed(0);
    return calculatedAmount;
  }
}
