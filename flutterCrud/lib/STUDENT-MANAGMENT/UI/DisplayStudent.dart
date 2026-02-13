import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/StudentController/StudentController.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/AddStudent.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/model/StudentModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Displaystudent extends StatelessWidget {
  Displaystudent({super.key});

  final Studentcontroller controller = Get.put(Studentcontroller());
  final TextEditingController searchController = TextEditingController();

  final Color primaryColor = const Color(0xFF6366F1);
  final Color slate900 = const Color(0xFF0F172A);
  final Color slate500 = const Color(0xFF64748B);
  final Color scaffoldBg = const Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1200;

            return Column(
              children: [
                _buildSearchBar(context, isMobile),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final results = controller.filteredStudents;
                    if (results.isEmpty) {
                      return const Center(child: Text("No students found."));
                    }
                    return _buildStudentList(results, context, isMobile, isTablet);
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 20,
        vertical: isMobile ? 8 : 10,
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => controller.searchQuery.value = value,
        decoration: InputDecoration(
          hintText: "Search by name...",
          hintStyle: TextStyle(fontSize: isMobile ? 13 : 14),
          prefixIcon: Icon(Icons.search, size: isMobile ? 18 : 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isMobile ? 12 : 15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentList(List<StudentModel> results, BuildContext context, bool isMobile, bool isTablet) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : (isTablet ? 800 : 1200),
        ),
        child: isTablet
            ? _buildGridView(results, context)
            : _buildListView(results, context, isMobile),
      ),
    );
  }

  Widget _buildListView(List<StudentModel> results, BuildContext context, bool isMobile) {
    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final student = results[index];
        return InkWell(
          onTap: () => _showStudentDetails(context, student),
          child: _buildStudentItem(student, isMobile),
        );
      },
    );
  }

  Widget _buildGridView(List<StudentModel> results, BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final student = results[index];
        return InkWell(
          onTap: () => _showStudentDetails(context, student),
          child: _buildStudentCard(student),
        );
      },
    );
  }

  // --- UPDATED DELETE LOGIC TO PREVENT ENGINE EXCEPTION ---
  void _confirmDelete(BuildContext context, StudentModel student) {
    Get.defaultDialog(
      title: "Delete Student",
      middleText: "Are you sure you want to delete ${student.name}?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        if (student.id != null) {
          // 1. Close Confirmation Dialog immediately
          Get.back();

          // 2. Wait for the confirmation dialog animation to finish (approx 300ms)
          // This prevents the "Engine Disposed" error and the lag.
          await Future.delayed(const Duration(milliseconds: 300));

          // 3. Close the Student Detail card
          if (context.mounted) {
            Navigator.of(context).pop();
          }

          // 4. Wait for the detail card blur animation to fade out
          await Future.delayed(const Duration(milliseconds: 300));

          // 5. NOW perform the actual deletion
          // By doing it now, the background list updates AFTER the dialogs are gone.
          await controller.deleteStudent(student.id!);

          Get.snackbar(
            "Success",
            "${student.name} deleted",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      },
    );
  }

  void _showStudentDetails(BuildContext context, StudentModel student) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(Icons.close, color: slate500),
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit_outlined, color: primaryColor),
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              Get.to(() => const AddStudentPage(), arguments: student);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                            onPressed: () => _confirmDelete(dialogContext, student),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 45),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: primaryColor.withOpacity(0.1),
                          child: Text(
                            student.name.isNotEmpty ? student.name[0].toUpperCase() : "?",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          student.name,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: slate900),
                        ),
                        const SizedBox(height: 8),
                        _buildStatusBadge(student.isGraduated, false),
                        const SizedBox(height: 32),
                        _buildDetailRow(Icons.person_outline, "Age", "${student.age} Years"),
                        const Divider(height: 32),
                        _buildDetailRow(Icons.calendar_month_outlined, "Joined Date",
                            DateFormat('MMMM dd, yyyy').format(student.joinedAt)),
                        const Divider(height: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.book_outlined, color: primaryColor, size: 18),
                                const SizedBox(width: 8),
                                Text("Registered Subjects", style: TextStyle(color: slate500, fontWeight: FontWeight.w600, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: student.subjects.map((s) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: scaffoldBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(s, style: TextStyle(color: slate900, fontSize: 13)),
                              )).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: slate500, fontSize: 11)),
            Text(value, style: TextStyle(color: slate900, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        )
      ],
    );
  }

  Widget _buildStudentItem(StudentModel student, bool isMobile) {
    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: isMobile ? 22 : 25,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Text(student.name.isNotEmpty ? student.name[0].toUpperCase() : "?",
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: isMobile ? 16 : 18)),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name, style: TextStyle(fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.bold, color: slate900), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text("Joined: ${DateFormat('MMM dd, yyyy').format(student.joinedAt)}", style: TextStyle(fontSize: isMobile ? 11 : 12, color: slate500)),
                ],
              ),
            ),
            _buildStatusBadge(student.isGraduated, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(StudentModel student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: primaryColor.withOpacity(0.1),
            child: Text(student.name.isNotEmpty ? student.name[0].toUpperCase() : "?", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Text(student.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: slate900), overflow: TextOverflow.ellipsis),
          Text("Age: ${student.age}", style: TextStyle(fontSize: 11, color: slate500)),
          const Spacer(),
          _buildStatusBadge(student.isGraduated, false),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isGraduated, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 8, vertical: isMobile ? 3 : 4),
      decoration: BoxDecoration(color: isGraduated ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(
        isGraduated ? "GRADUATED" : "IN PROGRESS",
        style: TextStyle(color: isGraduated ? Colors.green[700] : Colors.orange[700], fontSize: isMobile ? 8 : 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}