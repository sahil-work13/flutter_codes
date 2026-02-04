import 'package:flutter/material.dart';

import 'GET_API/CommentView.dart';
import 'GET_API/ComplexExample.dart';
import 'GET_API//GetApi.dart';
import 'GET_API//getPhotos.dart';
import 'POST_API/AddProduct_API.dart';
import 'POST_API/DeleteProduct_ApI.dart';
import 'POST_API/Signup_API.dart';
import 'SHARED PREFERENCE/sharedPreference.dart';
import 'UserView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RestApi Demo',
      theme: ThemeData(

        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Sharedpreference()
    );
  }
}

