import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_app/models/ProductModel.dart';
import 'package:http/http.dart';
class ApiServices {
  static Future<List<ProductModel>> fetchProducts() async{
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    final List data = jsonDecode(response.body);
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}