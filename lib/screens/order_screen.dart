import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../widgets/empty_state_view.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orders;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'My Order History',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF0F172A)),
        ),
      ),
      body: orders.isEmpty
          ? const EmptyStateView(
              icon: Icons.receipt_long_outlined,
              title: 'Koi order nahi mila',
              subtitle: 'Aapne abhi tak koi order place nahi kiya hai.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final order = orders[index];
                final isCancelled = order.status == 'Cancelled';

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCancelled ? Colors.red.shade200 : Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 20,
                                color: isCancelled ? Colors.red : const Color(0xFF1E3A8A),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Order #${order.id}',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isCancelled ? Colors.red.shade50 : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isCancelled ? Icons.cancel_outlined : Icons.check_circle_outline,
                                  size: 14,
                                  color: isCancelled ? Colors.red.shade700 : Colors.green.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  order.status,
                                  style: TextStyle(
                                    color: isCancelled ? Colors.red.shade700 : Colors.green.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(order.dateTime),
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      const Divider(height: 20),
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.product.title} (x${item.quantity})',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isCancelled ? Colors.grey : const Color(0xFF0F172A),
                                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                              Text(
                                '\$${item.subtotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: isCancelled ? Colors.grey : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text(
                            '\$${order.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: isCancelled ? Colors.grey : const Color(0xFF1E3A8A),
                            ),
                          ),
                        ],
                      ),
                      if (!isCancelled) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  title: const Text('Cancel this Order?'),
                                  content: const Text('Kya aap sach me is order ko cancel karna chahte hain?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('No, Keep Order'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<OrderProvider>().cancelOrder(order.id);
                                        Navigator.pop(ctx);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Order cancel kar diya gaya hai.'),
                                            backgroundColor: Colors.redAccent,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.close_rounded, size: 16, color: Colors.redAccent),
                            label: const Text(
                              'Cancel Order',
                              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red.shade200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}