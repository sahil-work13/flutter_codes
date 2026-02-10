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
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using a Container with decoration for a subtle gradient background
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF2F2F2)], // Soft off-white
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Main Logo Section
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 1200),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  // Replace with your actual logo asset
                  const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.blueAccent),
                  const SizedBox(height: 16),
                  Text(
                    "PRODUCT APP",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 4.0,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Elegant loading indicator at the bottom
            const SizedBox(
              width: 40,
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                color: Colors.blueAccent,
                minHeight: 2,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}