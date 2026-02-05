import 'package:flutter/material.dart';
import 'package:hive_db/SIMPLE-SHARED-PREFERENCE-PRACTICE/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SharedHelper.dart';
import 'SharedHelper.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      login();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SP"),centerTitle: true,backgroundColor: Colors.lightBlue,),

      body:
       Container(
          color: Colors.white,
          child:
          Center(child: Container(child: Icon(Icons.network_wifi)))
          ,
        ),


    );
  }
  Future<void> login()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    bool? isLoggedIn = await pref.getBool('isLoggedIn');
    Future.delayed(Duration(seconds: 3));
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
