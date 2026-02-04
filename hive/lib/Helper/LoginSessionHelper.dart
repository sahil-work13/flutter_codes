import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_db/TODO-APP/AddTask.dart';
import 'package:hive_db/TODO-APP/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginsessionhelper {

  Future<void> loginUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> checkLoginStatus(BuildContext context) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = await prefs.getBool('isLoggedIn') ?? false;

  if (isLoggedIn) {
    // Navigator.pushAndRemoveUntil clears the back-button history
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Addtask()),
          (route) => false, // This 'false' removes all previous screens
    );
  } else {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }
}
}