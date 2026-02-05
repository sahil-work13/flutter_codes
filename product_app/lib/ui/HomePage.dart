import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_app/controllers/product_controller.dart';
import 'package:product_app/routes/app_routes.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Homepage> {
  final controller = Get.find<ProductController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products"),centerTitle: true,backgroundColor: Colors.lightBlue,
      actions: [
        IconButton(onPressed: (){
          Get.toNamed(AppRoutes.profile);
        }, icon: Icon(Icons.person))
      ],),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (_, index) {
            final product = controller.products[index];
            return ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: Image.network(
                  product.image.toString(),
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(product.title.toString()),
              subtitle: Text("\$${product.price}"),
              onTap: () =>
                  Get.toNamed(AppRoutes.product, arguments: product),
            );
          },
        );
      }),
    );
  }
}

