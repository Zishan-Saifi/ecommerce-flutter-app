import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final categories = provider.categories;

    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = provider.selectedCategory == cat;

          return ChoiceChip(
            label: Text(
              cat[0].toUpperCase() + cat.substring(1).replaceAll('-', ' '),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF334155),
              ),
            ),
            selected: isSelected,
            selectedColor: const Color(0xFF1E3A8A),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey.shade300,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (_) => provider.selectCategory(cat),
          );
        },
      ),
    );
  }
}