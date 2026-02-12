import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/StudentController/StudentServices.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/Dashboard.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/Signup.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/model/StudentModel.dart';
import 'package:get/get.dart';

class Studentcontroller extends GetxController{
  var students = <StudentModel>[].obs;
  var isLoading = false.obs;
  final Studentservices _service =Studentservices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var searchQuery = "".obs;

  void onInit(){
    students.bindStream(_service.getStudent());
    super.onInit();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      await FirebaseAuth.instance.signInWithPopup(googleProvider);
      Get.off(() => DashboardScreen());

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

  Future<void> add(StudentModel students) async{
    isLoading.value = true;
    await _service.addStudent(students);
    isLoading.value = false;
  }

  void getStudentsForDisplay() {
    isLoading.value = true;

    students.bindStream(
      _service.getStudent(), // Stream<List<StudentModel>>
    );

    isLoading.value = false;
  }

  //search
  List<StudentModel> get filteredStudents {
    if (searchQuery.isEmpty) {
      return students;
    } else {
      return students
          .where((s) => s.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

// Method for Logout
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => const Signup());
  }
}