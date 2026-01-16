import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;

  const ProfileSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(title, style: AppTypography.headline5),
    );
  }
}
