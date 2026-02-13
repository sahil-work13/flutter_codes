import 'package:flutter/material.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/DisplayStudent.dart';
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

  // Track if we are in Edit Mode
  StudentModel? editingStudent;

  // Production Palette
  final Color primaryColor = const Color(0xFF6366F1);
  final Color slate900 = const Color(0xFF0F172A);
  final Color slate500 = const Color(0xFF64748B);

  // Available subjects for the chips
  final List<String> availableSubjects = ["Math", "Science", "History", "Physics", "Art"];

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if we are editing an existing student
    if (Get.arguments != null && Get.arguments is StudentModel) {
      editingStudent = Get.arguments as StudentModel;
      nameController.text = editingStudent!.name;
      ageController.text = editingStudent!.age.toString();
      selectedDate = editingStudent!.joinedAt;
      isGraduated = editingStudent!.isGraduated;
      selectedSubjects = List<String>.from(editingStudent!.subjects);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final double horizontalPadding = isMobile ? 24.0 : (isTablet ? 40.0 : 60.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          editingStudent == null ? "Add New Student" : "Edit Student Details",
          style: TextStyle(
            color: slate900,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 18 : 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(nameController, "Full Name", Icons.person_outline, "Enter student name", isMobile),
              const SizedBox(height: 20),
              _buildTextField(ageController, "Age", Icons.cake_outlined, "Enter age", isMobile, isNumeric: true),
              const SizedBox(height: 24),

              // Date Picker
              Text("Joining Date", style: TextStyle(fontSize: isMobile ? 13 : 14, fontWeight: FontWeight.w600, color: slate500)),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
                  child: Row(children: [Icon(Icons.calendar_month, color: primaryColor, size: 20), const SizedBox(width: 12), Text(DateFormat('MMMM dd, yyyy').format(selectedDate))]),
                ),
              ),

              const SizedBox(height: 24),
              Text("Subjects", style: TextStyle(fontSize: isMobile ? 13 : 14, fontWeight: FontWeight.w600, color: slate500)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableSubjects.map((subject) {
                  final isSelected = selectedSubjects.contains(subject);
                  return FilterChip(
                    label: Text(subject, style: TextStyle(fontSize: isMobile ? 12 : 13, color: isSelected ? Colors.white : slate900)),
                    selected: isSelected,
                    onSelected: (bool value) {
                      setState(() {
                        if (value) {
                          selectedSubjects.add(subject);
                        } else {
                          selectedSubjects.remove(subject);
                        }
                      });
                    },
                    selectedColor: primaryColor,
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: isSelected ? primaryColor : Colors.grey[200]!)),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              SwitchListTile(
                title: Text("Is Graduated?", style: TextStyle(fontSize: isMobile ? 14 : 15, fontWeight: FontWeight.w500, color: slate900)),
                value: isGraduated,
                activeColor: primaryColor,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool value) => setState(() => isGraduated = value),
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final student = StudentModel(
                      id: editingStudent?.id,
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      isGraduated: isGraduated,
                      joinedAt: selectedDate,
                      subjects: selectedSubjects,
                    );

                    if (editingStudent == null) {
                      await controller.add(student);
                      // Close the page/dialog FIRST
                      Get.back();
                      // Then show the success message on the underlying screen
                      Get.snackbar(
                        "Success",
                        "Student records saved.",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green,colorText: Colors.white,
                        margin: const EdgeInsets.all(15),
                      );
                      nameController.clear();
                      ageController.clear();
                      selectedDate = DateTime.now(); // Reset to current date
                      isGraduated = false;           // Reset checkbox/switch
                      selectedSubjects = [];         // Clear the list of subjects
                      editingStudent = null;
                    } else {
                      await controller.updateStudent(student);
                      // Navigate to the list and clear the stack
                      Get.off(() => Displaystudent());
                      Get.snackbar(
                        "Updated",
                        "Student details updated successfully.",
                        snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green,colorText: Colors.white,
                        margin: const EdgeInsets.all(15),
                      );
                    }
                  }
                },
                child: Text(
                  editingStudent == null ? "Save Student" : "Update Records",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String hint, bool isMobile, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      style: TextStyle(fontSize: isMobile ? 14 : 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(fontSize: isMobile ? 14 : 16),
        hintStyle: TextStyle(fontSize: isMobile ? 13 : 14),
        prefixIcon: Icon(icon, color: primaryColor, size: isMobile ? 20 : 24),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: isMobile ? 12 : 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2)),
      ),
      validator: (value) => value!.isEmpty ? "This field is required" : null,
    );
  }
}