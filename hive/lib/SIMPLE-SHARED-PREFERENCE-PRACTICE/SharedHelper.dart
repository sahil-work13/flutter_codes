import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_db/SIMPLE-SHARED-PREFERENCE-PRACTICE/Login.dart';
import 'package:hive_db/SIMPLE-SHARED-PREFERENCE-PRACTICE/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sharedhelper {

  Future<void> loginHelper() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> login(BuildContext context) async{
    await Future.delayed(Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if(isLoggedIn == true)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
    }
    else
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
    }
  }
}