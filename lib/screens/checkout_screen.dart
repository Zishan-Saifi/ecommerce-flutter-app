import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Zishan Saifi');
  final _phoneCtrl = TextEditingController(text: '+91 9876543210');
  final _addressCtrl = TextEditingController(text: 'Flat 402, Green Avenue, New Delhi');
  final _promoCtrl = TextEditingController();

  String? _appliedPromo;
  double _discountPercent = 0.0;
  String? _promoError;
  int _selectedPaymentMethod = 0;

  void _applyPromo(String code) {
    final cleanCode = code.trim().toUpperCase();
    setState(() {
      _promoError = null;
      if (cleanCode == 'LUXE50') {
        _appliedPromo = 'LUXE50';
        _discountPercent = 0.50;
      } else if (cleanCode == 'SAVE20') {
        _appliedPromo = 'SAVE20';
        _discountPercent = 0.20;
      } else {
        _appliedPromo = null;
        _discountPercent = 0.0;
        _promoError = 'Invalid promo code. Try LUXE50 or SAVE20';
      }
    });
  }

  void _removePromo() {
    setState(() {
      _appliedPromo = null;
      _discountPercent = 0.0;
      _promoCtrl.clear();
      _promoError = null;
    });
  }

  void _placeOrder() {
    // Agar form valid hai ya auto-fill hai
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kripya Delivery Address ki details sahi bharein!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final cart = context.read<CartProvider>();
    final subtotal = cart.subtotal;
    final discountAmount = subtotal * _discountPercent;
    final finalTotal = (subtotal - discountAmount) + cart.shippingFee;
    final orderId = 'LX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    // OrderProvider mein order safely save karo
    try {
      context.read<OrderProvider>().addOrder(cart.items, finalTotal);
    } catch (e) {
      debugPrint('OrderProvider error: $e');
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Confirmed!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 4),
            Text(
              'Order ID: #$orderId',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Text(
              'Total Paid: \$${finalTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E3A8A)),
            ),
            if (_appliedPromo != null) ...[
              const SizedBox(height: 4),
              Text(
                'Saved \$${discountAmount.toStringAsFixed(2)} with $_appliedPromo',
                style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
            const Divider(height: 28),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Delivery Timeline',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 12),
            _buildTimelineStep('Order Placed & Confirmed', 'Today, Just now', isDone: true, isCurrent: false),
            _buildTimelineStep('Packed & Quality Checked', 'Expected by Tomorrow', isDone: false, isCurrent: true),
            _buildTimelineStep('Out for Delivery', 'Estimated in 2-3 Days', isDone: false, isCurrent: false),
            _buildTimelineStep('Delivered', 'Delivering to ${_nameCtrl.text.trim()}', isDone: false, isCurrent: false, isLast: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  cart.clearCart();
                  Navigator.pop(ctx);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Back to Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(String title, String subtitle, {required bool isDone, required bool isCurrent, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? Colors.green : (isCurrent ? const Color(0xFF1E3A8A) : Colors.grey[300]),
              ),
              child: isDone ? const Icon(Icons.check, size: 10, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 22,
                color: isDone ? Colors.green : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isCurrent || isDone ? FontWeight.bold : FontWeight.w500,
                  color: isCurrent || isDone ? const Color(0xFF0F172A) : Colors.grey[600],
                ),
              ),
              Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
              if (!isLast) const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final subtotal = cart.subtotal;
    final discountAmount = subtotal * _discountPercent;
    final finalTotal = (subtotal - discountAmount) + cart.shippingFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF0F172A))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promo Code Section
              const Text('Apply Coupon Code', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promoCtrl,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              hintText: 'Enter coupon (e.g. LUXE50)',
                              hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                              prefixIcon: const Icon(Icons.confirmation_number_outlined, size: 20, color: Color(0xFF1E3A8A)),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_appliedPromo != null) {
                              _removePromo();
                            } else {
                              _applyPromo(_promoCtrl.text);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _appliedPromo != null ? Colors.redAccent : const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: Text(_appliedPromo != null ? 'Remove' : 'Apply', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    if (_promoError != null) ...[
                      const SizedBox(height: 6),
                      Text(_promoError!, style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                    if (_appliedPromo != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, size: 16, color: Colors.green),
                            const SizedBox(width: 6),
                            Text(
                              '$_appliedPromo applied! (${(_discountPercent * 100).toInt()}% Discount)',
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Available: ', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                        GestureDetector(
                          onTap: () {
                            _promoCtrl.text = 'LUXE50';
                            _applyPromo('LUXE50');
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFBFDBFE)),
                            ),
                            child: const Text('LUXE50 (50% OFF)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF1E3A8A))),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _promoCtrl.text = 'SAVE20';
                            _applyPromo('SAVE20');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFBFDBFE)),
                            ),
                            child: const Text('SAVE20 (20% OFF)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF1E3A8A))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Shipping Details Section
              const Text('Delivery Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person_outline, size: 20),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Name required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Phone required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Complete Address',
                        prefixIcon: const Icon(Icons.home_outlined, size: 20),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Address required' : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Payment Methods
              const Text('Payment Method', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    RadioListTile<int>(
                      value: 0,
                      groupValue: _selectedPaymentMethod,
                      title: const Text('Cash on Delivery (COD)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      secondary: const Icon(Icons.payments_outlined, color: Color(0xFF1E3A8A)),
                      onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                    ),
                    RadioListTile<int>(
                      value: 1,
                      groupValue: _selectedPaymentMethod,
                      title: const Text('UPI (Google Pay / PhonePe / Paytm)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      secondary: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF1E3A8A)),
                      onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                    ),
                    RadioListTile<int>(
                      value: 2,
                      groupValue: _selectedPaymentMethod,
                      title: const Text('Credit / Debit Card', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      secondary: const Icon(Icons.credit_card_outlined, color: Color(0xFF1E3A8A)),
                      onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Final Price Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Items Subtotal', style: TextStyle(color: Colors.grey)),
                        Text('\$${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    if (_appliedPromo != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Coupon Discount ($_appliedPromo)', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                          Text('-\$${discountAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Charges', style: TextStyle(color: Colors.grey)),
                        Text(
                          cart.shippingFee == 0 ? 'FREE' : '\$${cart.shippingFee.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cart.shippingFee == 0 ? Colors.green[700] : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        Text(
                          '\$${finalTotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, size: 18),
                      SizedBox(width: 8),
                      Text('Place Order Securely', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}