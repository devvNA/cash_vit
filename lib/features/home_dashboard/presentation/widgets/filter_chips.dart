import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelect;

  const FilterChips({
    super.key,
    required this.filters,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters
            .map(
              (filter) => Padding(
                padding: EdgeInsets.only(
                  right: filter == filters.last ? 0 : AppSpacing.sm,
                ),
                child: ChoiceChip(
                  label: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Text(
                      filter,
                      style: AppTypography.bodyMedium.copyWith(
                        color: selected == filter
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  selected: selected == filter,
                  onSelected: (_) => onSelect(filter),
                  selectedColor: AppColors.primaryBlue,
                  backgroundColor: AppColors.surfaceWhite,
                  side: BorderSide(
                    color: selected == filter
                        ? AppColors.primaryBlue
                        : AppColors.borderLight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
