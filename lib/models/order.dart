import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime dateTime;
  String status; // Yeh final nahi hona chahiye

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.dateTime,
    this.status = 'Confirmed',
  });
}