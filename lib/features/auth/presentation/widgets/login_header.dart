import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

/// Header section for login screen with logo and welcome text
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo Container
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: AppRadius.cardRadius,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        SizedBox(height: AppSpacing.xl),
        Text('Welcome Back', style: AppTypography.headline2),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Please enter your details to sign in',
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
