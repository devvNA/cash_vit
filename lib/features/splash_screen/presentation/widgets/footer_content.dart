import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

class FooterContent extends StatelessWidget {
  final double progress;

  const FooterContent({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.paddingScreen,
        0,
        AppSpacing.paddingScreen,
        64,
      ),
      child: Column(
        children: [
          // Minimalist Loading Bar
          Center(
            child: Column(
              children: [
                // Loading Bar Background
                Container(
                  height: 5,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                // Footer Text
                Text(
                  'By Devit Nur Azaqi',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'v1.0.0',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
