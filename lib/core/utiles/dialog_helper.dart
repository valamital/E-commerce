import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utiles/app_text.dart';

class DialogHelper {
  static void showErrorDialog(String title, String message) {
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

  static void showSuccessDialog() {
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

}
