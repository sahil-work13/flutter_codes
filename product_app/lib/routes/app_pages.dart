import 'package:get/get.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/ui/HomePage.dart';
import 'package:product_app/ui/LoginPage.dart';
import 'package:product_app/ui/ProductPage.dart';
import 'package:product_app/ui/ProfilePage.dart';
import 'package:product_app/ui/SignupPage.dart';

import '../ui/SplashScreen.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => SplashPage()),
    GetPage(name: AppRoutes.signup, page: () => Signuppage()),
    GetPage(name: AppRoutes.login, page: () => Loginpage()),
    GetPage(name: AppRoutes.home, page: () => Homepage()),
    GetPage(name: AppRoutes.product, page: () => Productpage()),
    GetPage(name: AppRoutes.profile, page: () => Profilepage()),
  ];
}
