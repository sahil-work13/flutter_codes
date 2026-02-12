import 'package:flutter/material.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/model/StudentModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/StudentController/StudentController.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(Studentcontroller());

  // Form Field Values
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isGraduated = false;
  List<String> selectedSubjects = [];

  // Production Palette
  final Color primaryColor = const Color(0xFF6366F1);
  final Color slate900 = const Color(0xFF0F172A);
  final Color slate500 = const Color(0xFF64748B);

  // Available subjects for the chips
  final List<String> availableSubjects = ["Math", "Science", "History", "Physics", "Art"];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    // Responsive values
    final horizontalPadding = isMobile ? 16.0 : (isTablet ? 24.0 : 32.0);
    final verticalSpacing = screenHeight < 700 ? 12.0 : 16.0;
    final maxWidth = isMobile ? screenWidth : (isTablet ? 700.0 : 800.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Add New Student",
          style: TextStyle(
            color: slate900,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 18 : 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: slate900),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(horizontalPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Personal Information", isMobile),
                    SizedBox(height: verticalSpacing),
                    _buildTextField(
                      nameController,
                      "Full Name",
                      Icons.person_outline,
                      "Enter student name",
                      isMobile,
                    ),
                    SizedBox(height: verticalSpacing),
                    _buildTextField(
                      ageController,
                      "Age",
                      Icons.cake_outlined,
                      "Enter age",
                      isMobile,
                      isNumeric: true,
                    ),
                    SizedBox(height: verticalSpacing * 2),
                    _buildSectionHeader("Academic Status", isMobile),
                    SizedBox(height: verticalSpacing),

                    // Boolean Toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Is Graduated?",
                        style: TextStyle(
                          color: slate900,
                          fontWeight: FontWeight.w500,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                      subtitle: Text(
                        "Toggle if student has completed the course",
                        style: TextStyle(
                          color: slate500,
                          fontSize: isMobile ? 11 : 12,
                        ),
                      ),
                      value: isGraduated,
                      activeColor: primaryColor,
                      onChanged: (val) => setState(() => isGraduated = val),
                    ),

                    SizedBox(height: verticalSpacing * 1.5),
                    _buildSectionHeader("Joining Date", isMobile),
                    SizedBox(height: verticalSpacing / 2),
                    _buildDatePicker(context, isMobile),

                    SizedBox(height: verticalSpacing * 2),
                    _buildSectionHeader("Subjects", isMobile),
                    SizedBox(height: verticalSpacing / 2),
                    _buildSubjectChips(isMobile),

                    SizedBox(height: screenHeight < 700 ? 32 : 48),
                    _buildSaveButton(isMobile, screenHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildDatePicker(BuildContext context, bool isMobile) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: primaryColor,
              size: isMobile ? 20 : 24,
            ),
            SizedBox(width: isMobile ? 8 : 12),
            Expanded(
              child: Text(
                DateFormat('dd MMM yyyy').format(selectedDate),
                style: TextStyle(
                  color: slate900,
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
            ),
            Text(
              "Change",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 13 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectChips(bool isMobile) {
    return Wrap(
      spacing: isMobile ? 6 : 8,
      runSpacing: isMobile ? 6 : 8,
      children: availableSubjects.map((subject) {
        final isSelected = selectedSubjects.contains(subject);

        return FilterChip(
          label: Text(
            subject,
            style: TextStyle(fontSize: isMobile ? 12 : 14),
          ),
          selected: isSelected,
          onSelected: (bool clickingNow) {
            setState(() {
              if (clickingNow) {
                selectedSubjects.add(subject);
              } else {
                selectedSubjects.remove(subject);
              }
            });
          },
          selectedColor: primaryColor.withOpacity(0.2),
          checkmarkColor: primaryColor,
          labelStyle: TextStyle(
            color: isSelected ? primaryColor : slate500,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 12,
            vertical: isMobile ? 4 : 8,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSaveButton(bool isMobile, double screenHeight) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight < 700 ? 48 : 56,
      child: ElevatedButton(
        onPressed: _saveStudent,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
          ),
        ),
        child: Text(
          "Save Student Profile",
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // --- LOGIC FUNCTIONS ---

  void _saveStudent() async{
    if (_formKey.currentState!.validate()) {
      final newStudent = StudentModel(
        name: nameController.text,
        age: int.parse(ageController.text),
        isGraduated: isGraduated,
        joinedAt: selectedDate,
        subjects: selectedSubjects,
      );
      await controller.add(newStudent);
      Get.snackbar("Success", "Succesfully added to database",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,colorText: Colors.white);

      _formKey.currentState!.reset();
      nameController.clear();
      ageController.clear();
      setState(() {
        selectedSubjects.clear();
        isGraduated = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  // --- UI HELPERS ---

  Widget _buildSectionHeader(String title, bool isMobile) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isMobile ? 16 : 18,
        fontWeight: FontWeight.bold,
        color: slate900,
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      String hint,
      bool isMobile, {
        bool isNumeric = false,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      style: TextStyle(fontSize: isMobile ? 14 : 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(fontSize: isMobile ? 14 : 16),
        hintStyle: TextStyle(fontSize: isMobile ? 13 : 14),
        prefixIcon: Icon(
          icon,
          color: primaryColor,
          size: isMobile ? 20 : 24,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 12 : 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      validator: (val) => val!.isEmpty ? "Required" : null,
    );
  }
}