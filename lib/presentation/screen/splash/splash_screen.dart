import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../core/utiles/image_constant.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.find<SplashController>();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          ImageConstant.shoppingLogo,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
