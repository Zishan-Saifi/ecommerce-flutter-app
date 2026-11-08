import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/storage_service.dart';

class CartProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  // Delivery free over $50, else $5
  double get shippingFee => (subtotal > 50 || _items.isEmpty) ? 0.0 : 5.0;

  double get grandTotal => subtotal + shippingFee;

  CartProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    _items = await _storageService.loadCart();
    notifyListeners();
  }

  Future<void> _persist() async {
    await _storageService.saveCart(_items);
  }

  void addToCart(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    _persist();
    notifyListeners();
  }

  void incrementQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      _persist();
      notifyListeners();
    }
  }

  void decrementQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      _persist();
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _persist();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _persist();
    notifyListeners();
  }
}