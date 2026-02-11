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

  // State for hiding/showing password
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    // 1. Define Production-Grade Color Palette (Hex Codes)
    const primaryColor = Color(0xFF6366F1); // Indigo
    const scaffoldBg = Color(0xFFF8FAFC);  // Soft Gray-Blue
    const Color slate900 = Color(0xFF0F172A); // Dark Heading
    const Color slate500 = Color(0xFF64748B); // Subtitle Grey

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea( // Ensures content doesn't hit the status bar
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                // Header Section
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: slate900, // FIXED: Removed 'Colors.'
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Join our Student Management System",
                  style: TextStyle(
                    fontSize: 16,
                    color: slate500, // FIXED: Removed 'Colors.'
                  ),
                ),
                const SizedBox(height: 40),

                // Input Section
                _buildInputField(
                  controller: email,
                  label: "Email Address",
                  hint: "example@college.com",
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),

                // Password Input with Toggle
                _buildInputField(
                  controller: password,
                  label: "Password",
                  hint: "Enter secure password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 32),

                // Primary Signup Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (email.text.isNotEmpty && password.text.isNotEmpty) {
                        Get.off(() => DashboardScreen());
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
                          borderRadius: BorderRadius.circular(16)
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("OR", style: TextStyle(color: Colors.grey[500])),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),

                const SizedBox(height: 24),

                // Google Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => controller.signInWithGoogle(),
                    // Use a Row or the icon property to house the image
                    icon: Image.asset(
                      'assets/images/google-logo.png',
                      height: 24,
                      width: 24,
                      // This catches the "File not found" or "Loading error"
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.login, // Your fallback icon
                          size: 24,
                          color: Colors.black54,
                        );
                      },
                    ),
                    label: const Text(
                      "Continue with Google",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1E293B), // Dark Slate
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12), // Extra breathing room
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for clean, reusable input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF1E293B)
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword ? _isPasswordHidden : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
            // Add eye icon for password fields
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              },
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}