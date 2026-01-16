import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

/// Forgot password link button
class ForgotPasswordLink extends StatelessWidget {
  final VoidCallback? onPressed;

  const ForgotPasswordLink({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: AppColors.primaryBlueDark,
        ),
        child: Text(
          'Forgot password?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
