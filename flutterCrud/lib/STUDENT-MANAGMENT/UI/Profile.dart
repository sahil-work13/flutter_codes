import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/StudentController/StudentController.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/Signup.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final Color primaryColor = const Color(0xFF6366F1);
  final Color slate900 = const Color(0xFF0F172A);
  final Color slate500 = const Color(0xFF64748B);
  final Color scaffoldBg = const Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    // Access the current logged-in user session
    final User? user = FirebaseAuth.instance.currentUser;
    // Find the existing controller for logout logic
    final Studentcontroller controller =
    Get.put(Studentcontroller());


    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final maxWidth = isMobile ? screenWidth : (isTablet ? 600.0 : 700.0);

    return Scaffold(
      backgroundColor: scaffoldBg,

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 32,
              vertical: isMobile ? 24 : 40,
            ),
            child: Column(
              children: [
                _buildProfileHeader(user, isMobile),
                SizedBox(height: isMobile ? 32 : 48),
                _buildInfoSection(user, isMobile),
                SizedBox(height: isMobile ? 32 : 48),
                _buildLogoutButton(controller, isMobile, screenHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User? user, bool isMobile) {
    return Column(
      children: [
        Stack(
          // Use Stack to place the 'Edit' icon over the photo
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                radius: isMobile ? 50 : 65,
                backgroundColor: primaryColor,
                // --- FIX: Logic to handle Image vs Icon properly ---
                backgroundImage:
                    (user?.photoURL != null && user!.photoURL!.isNotEmpty)
                    ? NetworkImage(user.photoURL!)
                    : null,
                child: (user?.photoURL == null || user!.photoURL!.isEmpty)
                    ? Text(
                        user?.email?.substring(0, 1).toUpperCase() ?? "U",
                        style: TextStyle(
                          fontSize: isMobile ? 40 : 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null, // Set child to null if image exists to prevent overlapping
              ),
            ),
            // Optional: A small edit badge to make it look professional
            Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: isMobile ? 16 : 20,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          user?.displayName ?? "Student User",
          style: TextStyle(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: slate900,
          ),
        ),
        Text(
          "Student ID: ${user?.uid.substring(0, 8).toUpperCase() ?? "N/A"}",
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: slate500,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(User? user, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile(
            Icons.email_outlined,
            "Email Address",
            user?.email ?? "No Email linked", // Dynamic Email
            isMobile,
          ),
          Divider(color: scaffoldBg, height: 1),
          _buildInfoTile(
            Icons.phone_outlined,
            "Phone Number",
            user?.phoneNumber ?? "+91 9974745061", // Dynamic Phone if available
            isMobile,
          ),
          Divider(color: scaffoldBg, height: 1),
          _buildInfoTile(
            Icons.verified_user_outlined,
            "User ID",
            user?.uid.substring(0, 8).toUpperCase() ??
                "NOTSET", // Unique ID segment
            isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
    bool isMobile,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 4 : 8,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryColor, size: isMobile ? 20 : 22),
      ),
      title: Text(
        label,
        style: TextStyle(fontSize: isMobile ? 11 : 12, color: slate500),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: isMobile ? 13 : 15,
          fontWeight: FontWeight.w600,
          color: slate900,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    Studentcontroller controller,
    bool isMobile,
    double screenHeight,
  ) {
    return OutlinedButton(
      // Now connected to your logout logic
      onPressed: () => _showLogoutDialog(controller),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(
          double.infinity,
          screenHeight < 700 ? 48 : (isMobile ? 48 : 56),
        ),
        side: const BorderSide(color: Colors.redAccent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
        ),
      ),
      child: const Text(
        "Sign Out",
        style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  void _showLogoutDialog(Studentcontroller controller) {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to sign out?",
      textConfirm: "Yes, Logout",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        FirebaseAuth.instance.signOut();
        Get.off(() => Signup()); // Or your signup route
      },
    );
  }
}
