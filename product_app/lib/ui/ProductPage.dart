import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_app/models/ProductModel.dart';

import '../routes/app_routes.dart';

class Productpage extends StatefulWidget {
  const Productpage({super.key});

  @override
  State<Productpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Productpage> {
   final ProductModel product = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products"),centerTitle: true,backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(onPressed: (){
            Get.toNamed(AppRoutes.profile);
          }, icon: Icon(Icons.person))
        ],),

      body:
      Column(
        children: [
        Image.network(product.image.toString(),height: 200,),
          Text("\$${product.price}", style: const TextStyle(fontSize: 24)),
          Text("Rating: ${product.rating}"),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(product.description.toString()),
          ),
        ],
      )
      ,
    );
  }
}
