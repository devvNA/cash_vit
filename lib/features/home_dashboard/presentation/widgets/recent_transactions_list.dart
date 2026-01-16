import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/home_dashboard/data/models/expense_model.dart';
import 'package:cash_vit/features/home_dashboard/presentation/providers/transaction_provider.dart';
import 'package:cash_vit/shared/extensions/currency_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RecentTransactionsList extends ConsumerWidget {
  final String filter;

  const RecentTransactionsList({super.key, required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);

    List<Expense> transactions = [];
    if (state is TransactionLoaded) {
      transactions = state.transactions.where((e) {
        if (filter == 'All') return true;
        if (filter == 'Income') return e.type == ExpenseType.income;
        if (filter == 'Expense') return e.type == ExpenseType.expense;
        return true;
      }).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent transactions', style: AppTypography.headline5),
            TextButton.icon(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                foregroundColor: AppColors.textSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
              ),
              icon: const Icon(Icons.chevron_right, size: 16),
              label: Text(
                'See All',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        if (transactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: AppRadius.cardRadius,
            ),
            child: Center(
              child: Text(
                'No transactions yet',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          Column(
            children: transactions
                .take(10)
                .toList()
                .asMap()
                .entries
                .map(
                  (entry) => TweenAnimationBuilder<double>(
                    key: ValueKey(entry.value.id),
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 300 + (entry.key * 80)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  entry.key == transactions.take(10).length - 1
                                  ? 0
                                  : AppSpacing.md,
                            ),
                            child: _TransactionTile(expense: entry.value),
                          ),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Expense expense;

  const _TransactionTile({required this.expense});

  @override
  Widget build(BuildContext context) {
    final category = TransactionCategory.getByName(expense.category ?? 'Other');
    final isIncome = expense.type == ExpenseType.income;

    final amountText = isIncome
        ? '+ ${expense.amount.toRupiah}'
        : '- ${expense.amount.toRupiah}';
    final amountColor = isIncome ? AppColors.incomeGreen : AppColors.expenseRed;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: AppRadius.cardRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: category.backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(category.icon, color: category.color),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  expense.category ?? 'Other',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountText,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                DateFormat('dd MMM').format(expense.date),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
