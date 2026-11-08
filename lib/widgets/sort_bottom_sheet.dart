import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sort Products By',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Default'),
            trailing: provider.currentSort == SortOption.defaultSort
                ? const Icon(Icons.check, color: Color(0xFF1E3A8A))
                : null,
            onTap: () {
              provider.setSortOption(SortOption.defaultSort);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Price: Low to High'),
            trailing: provider.currentSort == SortOption.priceLowToHigh
                ? const Icon(Icons.check, color: Color(0xFF1E3A8A))
                : null,
            onTap: () {
              provider.setSortOption(SortOption.priceLowToHigh);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Price: High to Low'),
            trailing: provider.currentSort == SortOption.priceHighToLow
                ? const Icon(Icons.check, color: Color(0xFF1E3A8A))
                : null,
            onTap: () {
              provider.setSortOption(SortOption.priceHighToLow);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Highest Customer Rating'),
            trailing: provider.currentSort == SortOption.ratingHighToLow
                ? const Icon(Icons.check, color: Color(0xFF1E3A8A))
                : null,
            onTap: () {
              provider.setSortOption(SortOption.ratingHighToLow);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}