import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(List<CartItem> cartItems, double total) {
    final newOrder = Order(
      id: 'LX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: List.from(cartItems),
      totalAmount: total,
      dateTime: DateTime.now(),
      status: 'Confirmed',
    );
    _orders.insert(0, newOrder);
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = 'Cancelled';
      notifyListeners();
    }
  }

  void removeOrder(String orderId) {
    _orders.removeWhere((o) => o.id == orderId);
    notifyListeners();
  }
}