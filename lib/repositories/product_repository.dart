import '../models/product.dart';
import '../services/api_service.dart';

class ProductRepository {
  final ApiService _apiService = ApiService();

  Future<List<Product>> getProducts({String? category, String? query}) {
    return _apiService.fetchProducts(category: category, searchQuery: query);
  }

  Future<List<String>> getCategories() {
    return _apiService.fetchCategories();
  }
}