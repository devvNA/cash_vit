import 'package:cash_vit/core/themes/index.dart';
import 'package:flutter/material.dart';

class AddTransactionActions extends StatelessWidget {
  final VoidCallback onDraft;
  final VoidCallback onAdd;

  const AddTransactionActions({
    super.key,
    required this.onDraft,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.xl,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Color(0xFFC1BFBF)),
                ),
                onPressed: onDraft,
                child: Text(
                  "Draft",
                  style: AppTypography.buttonMedium.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlueDark,
                  foregroundColor: Colors.white,
                ),
                onPressed: onAdd,
                child: Text(
                  "Add",
                  style: AppTypography.buttonMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
