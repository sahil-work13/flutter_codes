import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Assuming your StudentModel is in this project
// import 'package:fluttercrud/models/student_model.dart';

class StudentListStatic extends StatelessWidget {
  StudentListStatic({super.key});

  // 1. Static Mock Data (List of StudentModel)
  final List<Map<String, dynamic>> staticStudents = [
    {
      'name': 'Sahil Prajapati',
      'age': 21,
      'isGraduated': false,
      'joinedAt': DateTime(2022, 08, 15),
      'subjects': ['Flutter', 'Firebase', 'Dart'],
    },
    {
      'name': 'Anjali Sharma',
      'age': 22,
      'isGraduated': true,
      'joinedAt': DateTime(2021, 01, 10),
      'subjects': ['Java', 'Python', 'SQL'],
    },
    {
      'name': 'Rahul Verma',
      'age': 20,
      'isGraduated': false,
      'joinedAt': DateTime(2023, 06, 20),
      'subjects': ['C++', 'Algorithms'],
    },
  ];

  // Design Palette
  final Color primaryColor = const Color(0xFF6366F1);
  final Color slate900 = const Color(0xFF0F172A);
  final Color slate500 = const Color(0xFF64748B);
  final Color scaffoldBg = const Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text("Student Directory",
            style: TextStyle(color: slate900, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar Placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by name...",
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // The List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: staticStudents.length,
              itemBuilder: (context, index) {
                final student = staticStudents[index];
                return _buildStudentItem(student);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentItem(Map<String, dynamic> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Leading Avatar with Initials
            CircleAvatar(
              radius: 25,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Text(
                student['name'][0],
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),

            // Middle Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: slate900
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Joined: ${DateFormat('MMM dd, yyyy').format(student['joinedAt'])}",
                    style: TextStyle(fontSize: 12, color: slate500),
                  ),
                  const SizedBox(height: 8),
                  // Small Subject Chips
                  Wrap(
                    spacing: 4,
                    children: (student['subjects'] as List<String>).map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: scaffoldBg,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(s, style: const TextStyle(fontSize: 10)),
                    )).toList(),
                  )
                ],
              ),
            ),

            // Trailing Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildStatusBadge(student['isGraduated']),
                const SizedBox(height: 10),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isGraduated) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isGraduated ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isGraduated ? "GRADUATED" : "IN PROGRESS",
        style: TextStyle(
          color: isGraduated ? Colors.green[700] : Colors.orange[700],
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}