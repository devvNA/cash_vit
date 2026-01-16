import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        side: BorderSide(color: AppColors.expenseRed.withValues(alpha: 0.3)),
        foregroundColor: AppColors.expenseRed,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
      ),
      icon: const Icon(Icons.logout, size: 20),
      label: Text(
        'Log Out',
        style: AppTypography.buttonMedium.copyWith(color: AppColors.expenseRed),
      ),
    );
  }
}
