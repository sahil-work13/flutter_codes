import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  String? id; // This is the unique ID for THIS specific student document
  String name;
  int age;
  bool isGraduated;
  DateTime joinedAt;
  List<String> subjects;
  String userId; // <--- This is the "Owner Key" (The User's UID)

  StudentModel({
    this.id,
    required this.name,
    required this.age,
    required this.isGraduated,
    required this.joinedAt,
    required this.subjects,
    required this.userId, // Make it required
  });

  factory StudentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return StudentModel(
      id: documentId,
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      isGraduated: map['isGraduated'] ?? false,
      joinedAt: (map['joinedAt'] as Timestamp).toDate(),
      subjects: List<String>.from(map['subjects'] ?? []),
      userId: map['userId'] ?? '', // Map the owner ID here
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'isGraduated': isGraduated,
      'joinedAt': joinedAt,
      'subjects': subjects,
      'userId': userId, // Save the owner ID to Firestore
    };
  }
} 