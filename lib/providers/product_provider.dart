import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

enum SortOption { defaultSort, priceLowToHigh, priceHighToLow, ratingHighToLow }

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];
  List<String> _categories = ['All'];

  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  SortOption _currentSort = SortOption.defaultSort;

  // Getters
  List<Product> get products => _displayedProducts;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  SortOption get currentSort => _currentSort;

  Future<void> initialize() async {
    await fetchCategories();
    await fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await _apiService.fetchCategories();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allProducts = await _apiService.fetchProducts(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        searchQuery: _searchQuery,
      );
      _applySorting();
    } catch (e) {
      _errorMessage = 'Products load nahi ho sake. Kripya connection check karein.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _searchQuery = '';
    fetchProducts();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    fetchProducts();
  }

  void setSortOption(SortOption option) {
    _currentSort = option;
    _applySorting();
    notifyListeners();
  }

  void _applySorting() {
    _displayedProducts = List.from(_allProducts);
    switch (_currentSort) {
      case SortOption.priceLowToHigh:
        _displayedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        _displayedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.ratingHighToLow:
        _displayedProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.defaultSort:
        break;
    }
  }
}