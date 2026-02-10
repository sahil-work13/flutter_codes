import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_app/controllers/product_controller.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/ui/ProfilePage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent AppBar to blend with the background gradient
      appBar: AppBar(
        title: const Text(
          "PRODUCTS",
          style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey[800],
        actions: [
          IconButton(
            onPressed: () => Get.off(Profilepage()),
            icon: const Icon(Icons.person_outline, color: Colors.blueAccent),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF2F2F2)],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
            itemCount: controller.products.length,
            itemBuilder: (_, index) {
              final product = controller.products[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.network(
                        product.image.toString(),
                        fit: BoxFit.cover,
                        // Soft placeholder while image loads
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey[200], child: const Icon(Icons.image_not_supported_outlined)),
                      ),
                    ),
                  ),
                  title: Text(
                    product.title.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "\$${product.price}",
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: () => Get.toNamed(AppRoutes.product, arguments: product),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}