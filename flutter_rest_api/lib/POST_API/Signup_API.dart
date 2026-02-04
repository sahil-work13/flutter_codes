import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupApi extends StatefulWidget {
  const SignupApi({super.key});

  @override
  State<SignupApi> createState() => _SignupApiState();
}

class _SignupApiState extends State<SignupApi> {
  TextEditingController email =  new TextEditingController();
  TextEditingController password =  new TextEditingController();
  void login(String email,password) async{
   try{
     final response = await http.post(
       Uri.parse("https://sahil1.free.beeceptor.com/signup"),
       headers: {"Content-Type": "application/json"},
       body: jsonEncode({
         "email": email,
         "password": password
       }),
     );

     print(response.body);

   }catch(e){
     print(e.toString());
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup Api"),centerTitle: true,backgroundColor: Colors.lightBlue,),

      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(controller: email,decoration: InputDecoration(labelText: "Enter email",border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
            SizedBox(height: 10,),

            TextFormField(controller: password,decoration: InputDecoration(labelText: "Enter password",border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
            SizedBox(height: 10,),

            ElevatedButton(onPressed: (){
              login(email.text, password.text);
              print("Login Succeful");
            }, child: Text("Signup"))
          ],
        ),
      )
      ,
    );
  }
}
