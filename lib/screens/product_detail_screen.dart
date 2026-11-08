import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isFav = context.watch<FavoritesProvider>().isFavorite(product.id);
    final displayImages = product.images.isNotEmpty ? product.images : [product.thumbnail];
    final originalPrice = product.discountPercentage > 0 
        ? product.price / (1 - (product.discountPercentage / 100)) 
        : product.price;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          product.category.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E3A8A),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : const Color(0xFF0F172A),
            ),
            onPressed: () {
              context.read<FavoritesProvider>().toggleFavorite(product);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF0F172A)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product link copied to clipboard!'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Hero Image Display with clean Image.network
            Container(
              height: 320,
              width: double.infinity,
              color: Colors.white,
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.network(
                        displayImages[_selectedImageIndex],
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                        },
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product.discountPercentage.round()}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Thumbnail Strip
            if (displayImages.length > 1)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  height: 64,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: displayImages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final isSelected = _selectedImageIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedImageIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 64,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey.shade200,
                              width: isSelected ? 2.5 : 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFF8FAFC),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              displayImages[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // Pricing & Title Card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[500],
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      if (product.discountPercentage > 0) ...[
                        const SizedBox(width: 10),
                        Text(
                          '\$${originalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rating & Stock Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${product.reviews.length * 48} reviews)',
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: product.stock > 0 
                              ? Colors.green.withValues(alpha: 0.12)
                              : Colors.red.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              product.stock > 0 ? Icons.check_circle : Icons.cancel,
                              size: 14,
                              color: product.stock > 0 ? Colors.green[700] : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.stock > 0 ? 'In Stock (${product.stock} units)' : 'Sold Out',
                              style: TextStyle(
                                color: product.stock > 0 ? Colors.green[800] : Colors.red,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Highlights & Services
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildServiceBadge(Icons.local_shipping_outlined, 'Fast Delivery', 'Ships in 24h'),
                  _buildServiceBadge(Icons.verified_user_outlined, 'Authentic', '100% Genuine'),
                  _buildServiceBadge(Icons.assignment_return_outlined, '7 Days Return', 'No questions asked'),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Description & Quantity
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Overview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.6),
                  ),
                  const SizedBox(height: 20),

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Quantity',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Customer Reviews Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Customer Reviews',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        '${product.rating.toStringAsFixed(1)} ★ Rating',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...product.reviews.map((rev) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              rev.reviewerName,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                            Row(
                              children: List.generate(5, (starIdx) {
                                return Icon(
                                  starIdx < rev.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                                  size: 16,
                                  color: Colors.amber,
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          rev.comment,
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Add to Cart Button
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  onPressed: () {
                    for (int i = 0; i < _quantity; i++) {
                      context.read<CartProvider>().addToCart(product);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$_quantity item(s) cart mein add ho gaye!'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E3A8A),
                    side: const BorderSide(color: Color(0xFF1E3A8A), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Buy Now Button
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(
                  onPressed: () {
                    for (int i = 0; i < _quantity; i++) {
                      context.read<CartProvider>().addToCart(product);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                  icon: const Icon(Icons.flash_on_rounded, size: 18),
                  label: const Text('Buy Now', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceBadge(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF1E3A8A)),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
        const SizedBox(height: 2),
        Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
      ],
    );
  }
}