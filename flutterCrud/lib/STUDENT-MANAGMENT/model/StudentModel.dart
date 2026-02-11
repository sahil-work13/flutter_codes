import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  String? id;
  String name;      // String
  int age;          // int
  bool isGraduated; // bool
  DateTime joinedAt;// DateTime
  List<String> subjects; // Collection/List 

  StudentModel({
    this.id,
    required this.name,
    required this.age,
    required this.isGraduated,
    required this.joinedAt,
    required this.subjects,
  });

  // Convert Firestore Document to Model (Read) [cite: 34, 37]
  factory StudentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return StudentModel(
      id: documentId,
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      isGraduated: map['isGraduated'] ?? false,
      joinedAt: (map['joinedAt'] as Timestamp).toDate(), // Handling Firestore Timestamp
      subjects: List<String>.from(map['subjects'] ?? []),
    );
  }

  // Convert Model to Map (Create/Update) [cite: 34, 37]
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'isGraduated': isGraduated,
      'joinedAt': joinedAt,
      'subjects': subjects,
    };
  }
}