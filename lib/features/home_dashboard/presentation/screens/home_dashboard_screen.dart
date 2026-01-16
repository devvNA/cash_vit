import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/home_dashboard/data/models/expense_model.dart';
import 'package:cash_vit/features/home_dashboard/presentation/providers/transaction_provider.dart';
import 'package:cash_vit/features/profile/presentation/providers/profile_provider.dart';
import 'package:cash_vit/shared/extensions/currency_extension.dart';
import 'package:cash_vit/shared/widgets/background_glows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeDashboardScreen extends ConsumerStatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  ConsumerState<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  final List<String> _filters = const ['All', 'Income', 'Expense'];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundGlows(),
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: AppSpacing.paddingScreen,
                right: AppSpacing.paddingScreen,
                top: AppSpacing.lg,
                bottom: AppSpacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(),
                  SizedBox(height: AppSpacing.lg),
                  _FilterChips(
                    filters: _filters,
                    selected: _selectedFilter,
                    onSelect: (value) =>
                        setState(() => _selectedFilter = value),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  const _BalanceCard(),
                  SizedBox(height: AppSpacing.xl),
                  _RecentTransactions(filter: _selectedFilter),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  /// Helper method to capitalize first letter of a string
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    // Extract user's first name from profile state
    String userName = 'User';
    if (profileState is ProfileLoaded) {
      final rawName = profileState.profile.name?.firstname ?? 'User';
      userName = _capitalizeFirstLetter(rawName);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello,',
              style: AppTypography.headline5.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              userName,
              style: AppTypography.headline4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(999),
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
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.textPrimary,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelect;

  const _FilterChips({
    required this.filters,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters
            .map(
              (filter) => Padding(
                padding: EdgeInsets.only(
                  right: filter == filters.last ? 0 : AppSpacing.sm,
                ),
                child: ChoiceChip(
                  label: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Text(
                      filter,
                      style: AppTypography.bodyMedium.copyWith(
                        color: selected == filter
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  selected: selected == filter,
                  onSelected: (_) => onSelect(filter),
                  selectedColor: AppColors.primaryBlue,
                  backgroundColor: AppColors.surfaceWhite,
                  side: BorderSide(
                    color: selected == filter
                        ? AppColors.primaryBlue
                        : AppColors.borderLight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BalanceCard extends ConsumerWidget {
  const _BalanceCard();

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
                colors: [
                  AppColors.incomeGreen,
                  AppColors.incomeGreen,
                  AppColors.expenseRed,
                ],
                stops: [0.0, incomeRatio, 1.0],
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

class _RecentTransactions extends ConsumerWidget {
  final String filter;

  const _RecentTransactions({required this.filter});

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
