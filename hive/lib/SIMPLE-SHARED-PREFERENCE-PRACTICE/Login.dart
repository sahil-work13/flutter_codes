import 'package:flutter/material.dart';
import 'package:hive_db/SIMPLE-SHARED-PREFERENCE-PRACTICE/home.dart';

import 'SharedHelper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final helper  = Sharedhelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SP"),centerTitle: true,backgroundColor: Colors.lightBlue,),

      body:
      ElevatedButton(onPressed: () async{
        await helper.loginHelper();
        await helper.login(context);
      }, child: Text('Login'))
      ,
    );
  }
}
