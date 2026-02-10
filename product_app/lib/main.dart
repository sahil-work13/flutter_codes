import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_app/routes/app_pages.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/ui/HomePage.dart';
import 'package:product_app/ui/LoginPage.dart';
import 'package:product_app/ui/SplashScreen.dart';

import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthController(), permanent: true);
    Get.put(ProductController(), permanent: true);

    // 🔥 Start Firebase ONLY after first frame
    Future.microtask(() {
      auth.startAuthListener();
    });

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        final auth = Get.find<AuthController>();

        if (auth.isLoading.value) {
          return const SplashPage();
        }

        if (auth.firebaseuser.value == null) {
          return const Loginpage();
        }

        return const Homepage();
      }),
    );
  }
}
