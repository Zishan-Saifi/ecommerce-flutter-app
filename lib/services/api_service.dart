import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  Future<List<Product>> fetchProducts({String? category, String? searchQuery}) async {
    String url = '$baseUrl/products?limit=100';

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      url = '$baseUrl/products/search?q=${Uri.encodeComponent(searchQuery.trim())}';
    } else if (category != null && category.isNotEmpty && category != 'All') {
      url = '$baseUrl/products/category/${Uri.encodeComponent(category)}';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List productsJson = data['products'] as List;
      return productsJson.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products from API');
    }
  }

  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/products/category-list'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return ['All', ...data.map((e) => e.toString())];
    } else {
      return ['All'];
    }
  }
}