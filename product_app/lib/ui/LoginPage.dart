import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_app/controllers/auth_controller.dart';
import 'package:product_app/services/session_services.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final AuthController auth = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products"),centerTitle: true,backgroundColor: Colors.lightBlue,),

      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController,decoration: InputDecoration(labelText: "Enter email",border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
            SizedBox(height: 20,),
            TextField(controller: passwordController,decoration: InputDecoration(labelText: "Enter password",border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                auth.loginController(emailController.text);
              },
              child: const Text("Login"),
            )
          ],
        ),
      )
      ,
    );
  }
}
