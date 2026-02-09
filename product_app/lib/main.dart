import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_app/firebase_options.dart';
import 'package:product_app/routes/app_pages.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/ui/HomePage.dart';
import 'package:product_app/ui/LoginPage.dart';
import 'package:product_app/ui/SplashScreen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Get.putAsync<AuthController>(() async {
    final controller = AuthController();
    await controller.init(); // custom async init
    return controller;
  }, permanent: true);
  Get.put(ProductController());
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      home: Obx(() {
        final authController = Get.find<AuthController>();

        return authController.firebaseuser.value == null ? const Loginpage() : const Homepage();
      },),
    );
  }
}
