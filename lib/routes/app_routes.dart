



import 'package:get/get_navigation/src/routes/get_route.dart';

import '../presentation/screen/cart/binding/cart_binding.dart';
import '../presentation/screen/cart/binding/payment_binding.dart';
import '../presentation/screen/cart/cart_page.dart';
import '../presentation/screen/dashboard/binding/home_binding.dart';
import '../presentation/screen/dashboard/home_screen.dart';
import '../presentation/screen/product_details/binding/product_details_binding.dart';
import '../presentation/screen/product_details/product_details.dart';
import '../presentation/screen/splash/binding/splash_binding.dart';
import '../presentation/screen/splash/splash_screen.dart';


class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String loginScreen = '/login_screen';
  static const String registerScreen = '/register_screen';
  static const String homePage = '/home_page';
  static const String cartPage = '/cart_page';
  static const String productDetailsPage = '/product_detials';
  static List<GetPage> pages = [
    GetPage(
      name: cartPage,
      page: () => CartPage(),
      bindings: [
        cartBinding(),
        paymentBinding(),
      ],
    ),
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
      bindings: [
        splashBinding(),
      ],
    ),
    GetPage(
      name: homePage,
      page: () => HomeScreen(),
      bindings: [
        homeBinding(),
      ],
    ),
    GetPage(
      name: productDetailsPage,
      page: () => const ItemDetailPage(),
      bindings: [
        productDetailsBinding(),
      ],
    ),
  ];
}
