import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

class ProfileAvatarInfo extends StatelessWidget {
  final dynamic profile;

  const ProfileAvatarInfo({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    // Extract name
    final firstName = profile.name?.firstname ?? 'User';
    final lastName = profile.name?.lastname ?? '';
    final fullName = '$firstName $lastName'.trim();
    final email = profile.email ?? 'No email';
    final username = profile.username ?? '';

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backgroundLight,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Container(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    child: Center(
                      child: Text(
                        firstName[0],
                        style: AppTypography.display.copyWith(
                          color: AppColors.surfaceWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backgroundLight,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                  splashRadius: 20,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        Text(fullName, style: AppTypography.headline4),
        SizedBox(height: AppSpacing.xs),
        Text(
          email,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (username.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            '@$username',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
