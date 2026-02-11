import 'package:flutter/material.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/model/StudentModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:fluttercrud/STUDENT-MANAGMENT/StudentController/StudentController.dart';
// Ensure this points to your model file
// import 'package:fluttercrud/models/student_model.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final  controller = Get.put(Studentcontroller());

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Add New Student", style: TextStyle(color: slate900, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: slate900),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Personal Information"),
              const SizedBox(height: 16),
              _buildTextField(nameController, "Full Name", Icons.person_outline, "Enter student name"),
              const SizedBox(height: 16),
              _buildTextField(ageController, "Age", Icons.cake_outlined, "Enter age", isNumeric: true),

              const SizedBox(height: 32),
              _buildSectionHeader("Academic Status"),
              const SizedBox(height: 16),

              // 1. Boolean Toggle (Graduation Status)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Is Graduated?", style: TextStyle(color: slate900, fontWeight: FontWeight.w500)),
                subtitle: Text("Toggle if student has completed the course", style: TextStyle(color: slate500, fontSize: 12)),
                value: isGraduated,
                activeColor: primaryColor,
                onChanged: (val) => setState(() => isGraduated = val),
              ),

              const SizedBox(height: 24),
              // 2. Date Picker (Joined At)
              _buildSectionHeader("Joining Date"),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: primaryColor),
                      const SizedBox(width: 12),
                      Text(DateFormat('dd MMM yyyy').format(selectedDate), style: TextStyle(color: slate900)),
                      const Spacer(),
                      Text("Change", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              // 3. Multi-Select Chips (Subjects List)
              _buildSectionHeader("Subjects"),
              const SizedBox(height: 8),
              // ... inside your Wrap widget
              Wrap(
                spacing: 8,
                children: availableSubjects.map((subject) {
                  // Check if the list contains the subject to determine if chip is active
                  final isSelected = selectedSubjects.contains(subject);

                  return FilterChip(
                    label: Text(subject),
                    selected: isSelected,
                    onSelected: (bool clickingNow) { // clickingNow is the boolean value
                      setState(() {
                        if (clickingNow) {
                          // If the user clicked it to turn it ON, add to list
                          selectedSubjects.add(subject);
                        } else {
                          // If the user clicked it to turn it OFF, remove from list
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
                  );
                }).toList(),
              ),

              const SizedBox(height: 48),
              // 4. Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Save Student Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Logic Functions ---

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      // Create Model Instance
      final newStudent = StudentModel(
        name: nameController.text,
        age: int.parse(ageController.text),
        isGraduated: isGraduated,
        joinedAt: selectedDate,
        subjects: selectedSubjects,
      );

      // Call Controller (Assume you have an addStudent method)
      // controller.addStudent(newStudent);

      Get.back();
      Get.snackbar("Success", "Student added successfully", snackPosition: SnackPosition.BOTTOM);
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

  // --- UI Helpers ---

  Widget _buildSectionHeader(String title) {
    return Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: slate900));
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String hint, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
      ),
      validator: (val) => val!.isEmpty ? "Required" : null,
    );
  }
}