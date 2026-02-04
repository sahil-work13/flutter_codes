import 'package:flutter/material.dart';
import 'package:hive_db/Helper/LoginSessionHelper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Loginsessionhelper helper = Loginsessionhelper();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"),centerTitle: true,backgroundColor: Colors.lightBlue,),

      body:
      Center(
        child: Container(
          width: 300,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(controller: emailController,decoration: InputDecoration(hintText: "Enter email",
                  border:OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),

              SizedBox(height: 20,),

              TextField(controller: passwordController,decoration: InputDecoration(hintText: "Enter password",
                  border:OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),

              SizedBox(height: 20,),



              SizedBox(height: 25,),

              ElevatedButton(onPressed: () async{
              await helper.loginUser();
              await helper.checkLoginStatus(context);
              }, child: Text("Login")),
            ],
          ),
        ),
      )
      ,
    );
  }
}
