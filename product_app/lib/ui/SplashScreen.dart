import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/services/session_services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await Future.delayed(Duration(seconds: 3));
      final loggedIn = await SessionServices.isLoggedIn();
      print("IS LOGGED IN: $loggedIn");
      Get.offAllNamed(
        loggedIn ? AppRoutes.home : AppRoutes.login,
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
