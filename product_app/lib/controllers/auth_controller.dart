import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Added for Colors
import 'package:get/get.dart';
import 'package:product_app/ui/HomePage.dart';
import 'package:product_app/ui/LoginPage.dart';

class AuthController extends GetxController {
  FirebaseAuth? _auth;
  Rxn<User> firebaseuser = Rxn<User>();
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    startAuthListener();
  }

  void startAuthListener() {
    _auth = FirebaseAuth.instance;
    _auth!.authStateChanges().listen((user) {
      firebaseuser.value = user;
      isLoading.value = false;
    });
  }

  Future<void> signupController(String email, String password) async {
    try {
      _auth ??= FirebaseAuth.instance;
      await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => const Loginpage());
    } on FirebaseAuthException catch (e) {
      // This will show you exactly what is wrong in a popup
      Get.snackbar(
        "Auth Error",
        e.message ?? e.code,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loginController(String email, String password) async {
    try {
      _auth ??= FirebaseAuth.instance;
      await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => const Homepage());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Error",
        e.message ?? e.code,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> logoutController() async {
    await _auth?.signOut();
    Get.offAll(() => const Loginpage());
  }
}