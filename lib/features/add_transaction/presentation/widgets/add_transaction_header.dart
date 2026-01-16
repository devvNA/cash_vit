import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

class AddTransactionHeader extends StatelessWidget {
  const AddTransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleButton(
          icon: Icons.chevron_left,
          onTap: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 48,
              ), // Match button width for perfect center
              child: Text('Add transaction', style: AppTypography.headline5),
            ),
          ),
        ),
      ],
    );
  }
}

class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}
