import 'package:firebase_auth/firebase_auth.dart';
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
    students.bindStream(_service.getStudent());
    super.onInit();
  }

  // --- ADDED THIS METHOD: To handle global tab switching ---
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await FirebaseAuth.instance.signInWithPopup(googleProvider);
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
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => const DashboardScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Signup Failed");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> add(StudentModel student) async {
    isLoading.value = true;
    await _service.addStudent(student);
    isLoading.value = false;
    // Automatically switch to List tab after adding
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