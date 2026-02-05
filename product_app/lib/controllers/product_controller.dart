import 'package:get/get.dart';
import 'package:product_app/models/ProductModel.dart';
import 'package:product_app/services/api_services.dart';

class ProductController extends GetxController{
  var products = <ProductModel>[].obs ;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try{
      isLoading.value = true;
      products.value = await ApiServices.fetchProducts();
    }catch(e){
      print(e);
    }finally{
      isLoading.value = false;
    }
  }
}