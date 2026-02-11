import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/Dashboard.dart';
import 'package:get/get.dart';

class Studentcontroller extends GetxController{
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

}