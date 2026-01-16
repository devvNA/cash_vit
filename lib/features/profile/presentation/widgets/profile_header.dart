import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          'Profile',
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: RoundIconButton(icon: Icons.settings, onPressed: () {}),
        ),
      ],
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 22),
        color: AppColors.textPrimary,
        onPressed: onPressed,
        splashRadius: 24,
      ),
    );
  }
}
