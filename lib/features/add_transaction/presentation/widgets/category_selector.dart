import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/home_dashboard/presentation/providers/transaction_provider.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final TransactionCategory selectedCategory;
  final ValueChanged<TransactionCategory> onCategoryChanged;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => CategoryPickerSheet(
        selectedCategory: selectedCategory,
        onCategorySelected: (category) {
          onCategoryChanged(category);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: AppRadius.mediumRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: selectedCategory.backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      selectedCategory.icon,
                      color: selectedCategory.color,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(selectedCategory.name, style: AppTypography.headline6),
                ],
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => _showCategoryPicker(context),
            icon: const Icon(Icons.expand_more),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class CategoryPickerSheet extends StatelessWidget {
  final TransactionCategory selectedCategory;
  final ValueChanged<TransactionCategory> onCategorySelected;

  const CategoryPickerSheet({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Category', style: AppTypography.headline5),
          SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: TransactionCategory.categories.map((category) {
              final isSelected = category.name == selectedCategory.name;
              return GestureDetector(
                onTap: () => onCategorySelected(category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? category.color.withValues(alpha: 0.1)
                        : AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? category.color
                          : AppColors.borderLight,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: category.backgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category.icon,
                          color: category.color,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        category.name,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? category.color
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
