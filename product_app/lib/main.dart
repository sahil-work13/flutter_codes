import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_app/routes/app_pages.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/ui/SplashScreen.dart';

import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';

void main() {
  runApp(const MyApp());
  Get.put(AuthController());
  Get.put(ProductController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,theme: ThemeData.light(),debugShowCheckedModeBanner: false,);
  }
}

