import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

/// Reusable text field for login/auth forms with consistent styling
class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool isEnabled;
  final Widget? suffixIcon;

  final double? width;
  final double fieldHeight;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.isEnabled = true,
    this.suffixIcon,
    this.width,
    this.fieldHeight = 52,
  });

  @override
  Widget build(BuildContext context) {
    final radius = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(
            label,
            style: AppTypography.headline6.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          width: width,
          height: fieldHeight,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              enabled: isEnabled,
              obscureText: obscureText,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),

                // bikin prefix icon selalu center + ikut tinggi field
                prefixIcon: SizedBox(
                  width: 48,
                  height: fieldHeight,
                  child: Center(
                    child: Icon(
                      prefixIcon,
                      size: 22,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                prefixIconConstraints: BoxConstraints.tightFor(
                  width: 48,
                  height: fieldHeight,
                ),

                suffixIcon: suffixIcon,
                suffixIconConstraints: BoxConstraints.tightFor(
                  width: 48,
                  height: fieldHeight,
                ),

                hintText: hintText,
                hintStyle: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                    width: 2,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                filled: true,
                fillColor: AppColors.surfaceWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
