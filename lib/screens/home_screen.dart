import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_filter_bar.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  int _selectedBottomNavIndex = 0;

  final List<Map<String, dynamic>> _promoBanners = [
    {
      'tag': 'LIMITED TIME',
      'title': 'Mega Summer Sale\nUp to 50% OFF',
      'subtitle': 'Code: LUXE50',
      'colors': [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
      'icon': Icons.local_fire_department_rounded,
    },
    {
      'tag': 'NEW ARRIVALS',
      'title': 'Luxury Fragrances &\nBeauty Essentials',
      'subtitle': 'Explore Top Brands',
      'colors': [const Color(0xFF7C2D12), const Color(0xFFEA580C)],
      'icon': Icons.diamond_outlined,
    },
    {
      'tag': 'FREE DELIVERY',
      'title': 'On All Orders\nAbove \$49.00',
      'subtitle': 'No Coupon Required',
      'colors': [const Color(0xFF065F46), const Color(0xFF10B981)],
      'icon': Icons.local_shipping_outlined,
    },
  ];

  void _showSortSheet(BuildContext context) {
    final provider = context.read<ProductProvider>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort Products By',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSortOption(
                context: context,
                title: 'Featured / Default',
                icon: Icons.star_border,
                option: SortOption.defaultSort,
                current: provider.currentSort,
              ),
              _buildSortOption(
                context: context,
                title: 'Price: Low to High',
                icon: Icons.arrow_upward,
                option: SortOption.priceLowToHigh,
                current: provider.currentSort,
              ),
              _buildSortOption(
                context: context,
                title: 'Price: High to Low',
                icon: Icons.arrow_downward,
                option: SortOption.priceHighToLow,
                current: provider.currentSort,
              ),
              _buildSortOption(
                context: context,
                title: 'Customer Rating',
                icon: Icons.thumb_up_alt_outlined,
                option: SortOption.ratingHighToLow,
                current: provider.currentSort,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required SortOption option,
    required SortOption current,
  }) {
    final isSelected = current == option;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey[600]),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF1E3A8A) : Colors.black87,
          ),
        ),
        trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF1E3A8A)) : null,
        onTap: () {
          context.read<ProductProvider>().setSortOption(option);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartCount = context.watch<CartProvider>().totalItemCount;
    final favCount = context.watch<FavoritesProvider>().favorites.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WELCOME BACK 👋',
              style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: Colors.grey[500], fontWeight: FontWeight.w700),
            ),
            const Text(
              'LuxeStore',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFF0F172A)),
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_outline, color: Color(0xFF0F172A)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  );
                },
              ),
              if (favCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      favCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF0F172A)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E3A8A),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => productProvider.fetchProducts(),
        child: CustomScrollView(
          slivers: [
            // Search Bar & Filter Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchCtrl,
                          decoration: InputDecoration(
                            hintText: 'Search products, brands...',
                            hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                            prefixIcon: const Icon(Icons.search, size: 22, color: Color(0xFF1E3A8A)),
                            suffixIcon: _searchCtrl.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchCtrl.clear();
                                      productProvider.searchProducts('');
                                      setState(() {});
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onChanged: (val) => setState(() {}),
                          onSubmitted: (val) => productProvider.searchProducts(val),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A8A),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.white),
                        onPressed: () => _showSortSheet(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Promo Banner Carousel
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 135,
                    child: PageView.builder(
                      controller: _bannerController,
                      itemCount: _promoBanners.length,
                      onPageChanged: (i) => setState(() => _currentBannerIndex = i),
                      itemBuilder: (context, index) {
                        final b = _promoBanners[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: b['colors'],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (b['colors'][0] as Color).withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        b['tag'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      b['title'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      b['subtitle'],
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.85),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                b['icon'],
                                size: 55,
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_promoBanners.length, (i) {
                      final isActive = _currentBannerIndex == i;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                        width: isActive ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF1E3A8A) : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 6)),
            const SliverToBoxAdapter(child: CategoryFilterBar()),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Trending Collection',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      '${productProvider.products.length} Items',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Product Grid Content
            if (productProvider.isLoading)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(height: 10, width: 60, color: Colors.grey[200]),
                                const SizedBox(height: 6),
                                Container(height: 14, width: double.infinity, color: Colors.grey[200]),
                                const SizedBox(height: 8),
                                Container(height: 16, width: 50, color: Colors.grey[200]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    childCount: 4,
                  ),
                ),
              )
            else if (productProvider.errorMessage != null)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_rounded, size: 50, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(productProvider.errorMessage!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => productProvider.fetchProducts(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (productProvider.products.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 50, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('Koi products nahi mile.'),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ProductCard(product: productProvider.products[index]);
                    },
                    childCount: productProvider.products.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedBottomNavIndex,
          selectedItemColor: const Color(0xFF1E3A8A),
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: (index) {
            setState(() => _selectedBottomNavIndex = index);
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()))
                  .then((_) => setState(() => _selectedBottomNavIndex = 0));
            } else if (index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))
                  .then((_) => setState(() => _selectedBottomNavIndex = 0));
            } else if (index == 3) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderScreen()))
                  .then((_) => setState(() => _selectedBottomNavIndex = 0));
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: favCount > 0,
                label: Text(favCount.toString()),
                child: const Icon(Icons.favorite_outline),
              ),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text(cartCount.toString()),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'Orders',
            ),
          ],
        ),
      ),
    );
  }
}