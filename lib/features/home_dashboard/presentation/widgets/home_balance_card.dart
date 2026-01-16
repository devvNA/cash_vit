import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/home_dashboard/presentation/providers/transaction_provider.dart';
import 'package:cash_vit/shared/extensions/currency_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBalanceCard extends ConsumerWidget {
  const HomeBalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);

    double totalIncome = 0;
    double totalExpense = 0;

    if (state is TransactionLoaded) {
      totalIncome = state.totalIncome;
      totalExpense = state.totalExpense;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingCard),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BalanceLine(
                  color: AppColors.incomeGreen,
                  label: 'Income',
                  value: totalIncome.toRupiah,
                ),
                SizedBox(height: AppSpacing.lg),
                _BalanceLine(
                  color: AppColors.expenseRed,
                  label: 'Spent',
                  value: totalExpense.toRupiah,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          _BalanceProgress(income: totalIncome, expense: totalExpense),
        ],
      ),
    );
  }
}

class _BalanceLine extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _BalanceLine({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.headline6.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _BalanceProgress extends StatelessWidget {
  final double income;
  final double expense;

  const _BalanceProgress({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    final total = income + expense;
    final incomeRatio = total > 0 ? income / total : 0.5;

    return SizedBox(
      width: 112,
      height: 112,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: const [
                  AppColors.incomeGreen,
                  AppColors.incomeGreen,
                  AppColors.expenseRed,
                  AppColors.expenseRed,
                ],
                stops: [0.0, incomeRatio, incomeRatio, 1.0],
              ),
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.surfaceWhite,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
