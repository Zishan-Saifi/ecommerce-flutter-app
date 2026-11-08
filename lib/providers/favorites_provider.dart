import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/storage_service.dart';

class FavoritesProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  FavoritesProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    _favorites = await _storageService.loadFavorites();
    notifyListeners();
  }

  bool isFavorite(int productId) {
    return _favorites.any((item) => item.id == productId);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      _favorites.removeWhere((item) => item.id == product.id);
    } else {
      _favorites.add(product);
    }
    _storageService.saveFavorites(_favorites);
    notifyListeners();
  }
}