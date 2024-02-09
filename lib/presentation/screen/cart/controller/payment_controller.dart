import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../core/utiles/api_constant.dart';
import '../../../../core/utiles/app_text.dart';

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntent;

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