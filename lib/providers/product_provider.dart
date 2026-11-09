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
    await fetchProducts();
    await fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final fetched = await _apiService.fetchCategories();
      if (fetched.isNotEmpty) {
        final Set<String> uniqueCats = {'All'};
        for (var cat in fetched) {
          if (cat.trim().isNotEmpty) {
            uniqueCats.add(cat.trim());
          }
        }
        _categories = uniqueCats.toList();
        notifyListeners();
      }
    } catch (_) {
      // Agar API fail ho jaye, to loaded products se extract kar lo
      _extractCategoriesFromProducts();
    }
  }

  void _extractCategoriesFromProducts() {
    if (_allProducts.isNotEmpty) {
      final Set<String> cats = {'All'};
      for (var p in _allProducts) {
        if (p.category.trim().isNotEmpty) {
          // Capitalize first letter for neat display
          final cat = p.category.trim();
          cats.add(cat[0].toUpperCase() + cat.substring(1));
        }
      }
      _categories = cats.toList();
      notifyListeners();
    }
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allProducts = await _apiService.fetchProducts(
        category: _selectedCategory == 'All' ? null : _selectedCategory.toLowerCase(),
        searchQuery: _searchQuery,
      );

      // Agar categories abhi tak sirf 'All' hai, to products se categories nikal lo
      if (_categories.length <= 1) {
        _extractCategoriesFromProducts();
      }

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