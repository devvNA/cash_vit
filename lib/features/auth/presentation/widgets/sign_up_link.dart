import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

/// Sign up link for users without account
class SignUpLink extends StatelessWidget {
  final VoidCallback? onPressed;

  const SignUpLink({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Sign up now',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
