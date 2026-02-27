import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/market_asset.dart';

class CategoryFilterBar extends StatelessWidget {
  final AssetCategory? activeCategory;
  final ValueChanged<AssetCategory?> onCategoryChanged;

  const CategoryFilterBar({
    super.key,
    required this.activeCategory,
    required this.onCategoryChanged,
  });

  static const _categories = [
    (label: 'All', value: null),
    (label: 'Crypto', value: AssetCategory.crypto),
    (label: 'Stocks', value: AssetCategory.stocks),
    (label: 'Forex', value: AssetCategory.forex),
    (label: 'Commodities', value: AssetCategory.commodities),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _categories.map((cat) {
          final isActive = cat.value == activeCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CategoryFilterChip(
              label: cat.label,
              isActive: isActive,
              onTap: () => onCategoryChanged(cat.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CategoryFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const CategoryFilterChip({super.key, 
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
