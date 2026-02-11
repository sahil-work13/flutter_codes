import 'package:flutter/material.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  // Production Palette
  final Color primaryColor = const Color(0xFF6366F1);
  final Color slate900 = const Color(0xFF0F172A);
  final Color slate500 = const Color(0xFF64748B);
  final Color scaffoldBg = const Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("My Profile", style: TextStyle(color: slate900, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined, color: primaryColor)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // 1. Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 30),

            // 2. Info Sections
            _buildInfoSection("Academic Details", [
              _buildInfoTile(Icons.school_outlined, "Student ID", "STU-2024-001"),
              _buildInfoTile(Icons.calendar_month_outlined, "Batch", "2022 - 2026"),
              _buildInfoTile(Icons.book_outlined, "Current Semester", "6th Semester"),
            ]),

            const SizedBox(height: 20),

            _buildInfoSection("Contact Information", [
              _buildInfoTile(Icons.email_outlined, "Email", "sahil.prajapati@college.com"),
              _buildInfoTile(Icons.phone_outlined, "Phone", "+91 98765 43210"),
            ]),

            const SizedBox(height: 30),

            // 3. Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Text("SP", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: primaryColor)),
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: primaryColor,
              child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text("Sahil Prajapati", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: slate900)),
        Text("Computer Science Engineering", style: TextStyle(fontSize: 14, color: slate500)),
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: slate900)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: primaryColor, size: 22),
      title: Text(label, style: TextStyle(fontSize: 12, color: slate500)),
      subtitle: Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: slate900)),
    );
  }
}