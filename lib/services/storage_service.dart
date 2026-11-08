import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class StorageService {
  static const String _cartKey = 'saved_cart_items';
  static const String _favKey = 'saved_favorite_items';

  Future<void> saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((e) => e.toJson()).toList();
    await prefs.setString(_cartKey, json.encode(jsonList));
  }

  Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List decoded = json.decode(raw);
      return decoded.map((e) => CartItem.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFavorites(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = products.map((e) => e.toJson()).toList();
    await prefs.setString(_favKey, json.encode(jsonList));
  }

  Future<List<Product>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_favKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List decoded = json.decode(raw);
      return decoded.map((e) => Product.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}