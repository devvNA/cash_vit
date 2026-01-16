import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool emphasized;

  const PaymentMethodSelector({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    // Reference: Selected item has white background but blue border
    final borderColor = selected
        ? AppColors.primaryBlue
        : const Color(0xFFEEEEEE); // Softer border for unselected

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20), // Softer radius matches image
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: selected ? 2 : 1.5, // Thicker border for selection
          ),
          // Removed shadow slightly to match the flat clean look in image
        ),
        child: Row(
          children: [
            RadioDot(selected: selected),
            SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTypography.bodyLarge.copyWith(
                // Changed to bodyLarge for better sizing
                color: AppColors.textPrimary.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadioDot extends StatelessWidget {
  final bool selected;

  const RadioDot({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primaryBlue : AppColors.borderLight,
          width: 2,
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : Colors.transparent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
