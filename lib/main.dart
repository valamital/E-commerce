import 'package:e_commarce_app_demo/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  loadEnvFile();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51OdeOMSJQEYtiDHhweeosMFVkXTvF49kK7ykVAQJKuWVdsPWdV1NCHGz5Idmdj7Ah932Df9RUpiJFQGxmn4fJ0LW0085Hg9xcA";
  runApp(const MyApp());
}

Future<void> loadEnvFile() async {
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    if (kDebugMode) {
      print("Unable to load environment file, Please add your stripe secret key inside given path.");
    }

  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes.pages,
    );
  }
}
