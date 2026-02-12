import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/Dashboard.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/Signup.dart';
import 'package:get/get.dart';
// Import your next screens here
// import 'package:fluttercrud/STUDENT-MANAGMENT/UI/Signup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Initialize Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    // 2. Navigation Logic (Wait 3 seconds then go to Signup)
    Future.delayed(const Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Get.offAll(() => const DashboardScreen());
      } else {
        Get.offAll(() => const Signup());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF6366F1); // Your Indigo
    const Color slate900 = Color(0xFF0F172A);

    // Get screen dimensions
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Responsive sizing
    final bool isSmallScreen = width < 360;
    final bool isMediumScreen = width >= 360 && width < 600;
    final bool isTablet = width >= 600 && width < 900;
    final bool isDesktop = width >= 900;

    // Logo size based on screen size
    final double logoSize = isSmallScreen
        ? 80
        : isMediumScreen
        ? 100
        : isTablet
        ? 120
        : 140;

    // Icon size based on screen size
    final double iconSize = isSmallScreen
        ? 48
        : isMediumScreen
        ? 60
        : isTablet
        ? 72
        : 84;

    // Border radius based on screen size
    final double borderRadius = isSmallScreen
        ? 20
        : isMediumScreen
        ? 24
        : isTablet
        ? 28
        : 32;

    // Title font size
    final double titleFontSize = isSmallScreen
        ? 24
        : isMediumScreen
        ? 28
        : isTablet
        ? 32
        : 36;

    // Subtitle font size
    final double subtitleFontSize = isSmallScreen
        ? 10
        : isMediumScreen
        ? 12
        : isTablet
        ? 14
        : 16;

    // Letter spacing
    final double titleLetterSpacing = isSmallScreen ? 3 : 4;
    final double subtitleLetterSpacing = isSmallScreen ? 1.5 : 2;

    // Spacing
    final double spacingAfterLogo = isSmallScreen
        ? 20
        : isMediumScreen
        ? 24
        : isTablet
        ? 28
        : 32;

    final double spacingAfterText = isSmallScreen
        ? 40
        : isMediumScreen
        ? 48
        : isTablet
        ? 56
        : 64;

    // Loading indicator size
    final double loadingSize = isSmallScreen
        ? 18
        : isMediumScreen
        ? 20
        : isTablet
        ? 22
        : 24;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, // 5% horizontal padding
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Container
                  Container(
                    height: logoSize,
                    width: logoSize,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Icon(
                      Icons.school_rounded,
                      size: iconSize,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: spacingAfterLogo),

                  // App Name
                  Text(
                    "STUDENT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: titleLetterSpacing,
                      color: slate900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "MANAGEMENT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w500,
                      letterSpacing: subtitleLetterSpacing,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: spacingAfterText),

                  // Loading Indicator
                  SizedBox(
                    width: loadingSize,
                    height: loadingSize,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}