import 'package:flutter/material.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/Dashboard.dart';
import 'package:get/get.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/StudentController/StudentController.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final Studentcontroller controller = Get.put(Studentcontroller());

  bool _isPasswordHidden = true;

  // Production Palette
  static const primaryColor = Color(0xFF6366F1);
  static const scaffoldBg = Color(0xFFF8FAFC);
  static const slate900 = Color(0xFF0F172A);
  static const slate500 = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    // Adaptive sizing
    final horizontalPadding = isMobile ? 24.0 : (isTablet ? 40.0 : 48.0);
    final maxWidth = isMobile ? screenWidth : (isTablet ? 500.0 : 450.0);
    final topSpacing = screenHeight < 700 ? 40.0 : 60.0;
    final verticalSpacing = screenHeight < 700 ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: topSpacing),

                    // Header Section
                    _buildHeader(isMobile),
                    SizedBox(height: screenHeight < 700 ? 32 : 40),

                    // Input Section
                    _buildInputField(
                      controller: email,
                      label: "Email Address",
                      hint: "example@college.com",
                      icon: Icons.email_outlined,
                      isMobile: isMobile,
                    ),
                    SizedBox(height: verticalSpacing),

                    _buildInputField(
                      controller: password,
                      label: "Password",
                      hint: "Enter secure password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isMobile: isMobile,
                    ),

                    SizedBox(height: screenHeight < 700 ? 24 : 32),

                    // Primary Signup Button
                    _buildSignupButton(isMobile, screenHeight),

                    SizedBox(height: verticalSpacing),

                    // Divider
                    _buildDivider(isMobile),

                    SizedBox(height: verticalSpacing),

                    // Google Sign In Button
                    _buildGoogleButton(isMobile, screenHeight),

                    SizedBox(height: screenHeight < 700 ? 32 : 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create Account",
          style: TextStyle(
            fontSize: isMobile ? 28 : 32,
            fontWeight: FontWeight.bold,
            color: slate900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Join our Student Management System",
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: slate500,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton(bool isMobile, double screenHeight) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight < 700 ? 48 : (isMobile ? 50 : 56),
      child: ElevatedButton(
        onPressed: () {
          if (email.text.isNotEmpty && password.text.isNotEmpty) {
            controller.signUpWithEmailAndPassword(email.text.trim(), password.text.trim());
          } else {
            Get.snackbar(
              "Required",
              "Please fill all fields",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              margin: const EdgeInsets.all(15),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
          ),
          elevation: 0,
        ),
        child: Text(
          "Sign Up",
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isMobile) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "OR",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildGoogleButton(bool isMobile, double screenHeight) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight < 700 ? 48 : (isMobile ? 50 : 56),
      child: OutlinedButton.icon(
        onPressed: () => controller.signInWithGoogle(),
        icon: Image.asset(
          'assets/images/google-logo.png',
          height: isMobile ? 20 : 24,
          width: isMobile ? 20 : 24,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.login,
              size: isMobile ? 20 : 24,
              color: Colors.black54,
            );
          },
        ),
        label: Text(
          "Continue with Google",
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
          ),
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 8 : 12,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isMobile,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isMobile ? 13 : 14,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword ? _isPasswordHidden : false,
          style: TextStyle(fontSize: isMobile ? 14 : 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: isMobile ? 13 : 14,
            ),
            prefixIcon: Icon(
              icon,
              color: primaryColor,
              size: isMobile ? 20 : 24,
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _isPasswordHidden
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey,
                size: isMobile ? 20 : 24,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              },
            )
                : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 14 : 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}