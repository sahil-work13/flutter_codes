import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/StudentController/StudentServices.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/Dashboard.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/Signup.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/model/StudentModel.dart';
import 'package:get/get.dart';

class Studentcontroller extends GetxController {
  var students = <StudentModel>[].obs;
  var isLoading = false.obs;
  final Studentservices _service = Studentservices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var searchQuery = "".obs;

  // --- ADDED THIS LINE: The missing variable ---
  var selectedIndex = 0.obs; 

  @override
  void onInit() {
    refreshStudentStream();
    super.onInit();
  }

  void refreshStudentStream() {
  // This binds the stream again using the new user context
  students.bindStream(_service.getStudent());
}
  // --- ADDED THIS METHOD: To handle global tab switching ---
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await FirebaseAuth.instance.signInWithPopup(googleProvider);
      refreshStudentStream();
      Get.offAll(() => const DashboardScreen());
    } on FirebaseAuthException catch (e) {
      print("Google Sign-In Error: ${e.code}");
    } catch (e) {
      print("Unknown Error: $e");
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
    isLoading.value = true;

    try {
      // 1. Attempt to Login first
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("Login Successful");
    } on FirebaseAuthException catch (e) {
      // 2. If user is not found, attempt to Sign Up
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        print("User not found, attempting signup...");
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print("Signup Successful");
      } else {
        // Re-throw if it's a different error (like wrong password)
        rethrow;
      }
    }

    // 3. Common logic after successful Auth
    refreshStudentStream();
    Get.offAll(() => const DashboardScreen());
    
  } on FirebaseAuthException catch (e) {
    // Handle specific errors like 'wrong-password' or 'invalid-email'
    String message = "Authentication Failed";
    if (e.code == 'wrong-password') message = "Incorrect password.";
    if (e.code == 'invalid-email') message = "The email address is badly formatted.";
    
    Get.snackbar("Auth Error", message, 
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white
    );
  } finally {
    isLoading.value = false;
  }
  }

  Future<void> add(StudentModel student) async {
    isLoading.value = true;
    String? currentUid = _auth.currentUser?.uid; 

    if (currentUid != null) {
      
      await _service.addStudent(student, currentUid);
    } else {
      Get.snackbar("Error", "User not logged in");
    }
    isLoading.value = false;
    changeTab(2); 
  }

  Future<void> deleteStudent(String id) async {
    await _service.removeStudent(id);
  }

  Future<void> updateStudent(StudentModel student) async {
    isLoading.value = true;
    await _service.updateStudent(student);
    isLoading.value = false;
    // Automatically switch to List tab after updating
    changeTab(2);
  }

  List<StudentModel> get filteredStudents {
    if (searchQuery.isEmpty) {
      return students;
    } else {
      return students.where((student) {
        return student.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }
}