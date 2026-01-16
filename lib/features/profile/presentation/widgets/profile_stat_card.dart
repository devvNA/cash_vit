import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

class ProfileStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color backgroundColor;
  final Color valueColor;

  const ProfileStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.largeRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.headline5.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
