import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/profile/presentation/providers/profile_provider.dart';
import 'package:cash_vit/shared/widgets/background_glows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeDashboardScreen extends ConsumerStatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  ConsumerState<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  final List<String> _filters = const ['All', 'Daily', 'Weekly', 'Monthly'];
  String _selectedFilter = 'All';

  final List<_TransactionItem> _transactions = const [
    _TransactionItem(
      title: 'Food',
      subtitle: 'Card',
      amount: -12,
      date: 'Mar 07, 2023',
      icon: Icons.restaurant,
      backgroundColor: AppColors.categoryFuel,
      iconColor: AppColors.primaryBlue,
      period: 'Daily',
    ),
    _TransactionItem(
      title: 'Salary',
      subtitle: 'Bank Account',
      amount: 6800,
      date: 'Mar 07, 2023',
      icon: Icons.payments,
      backgroundColor: AppColors.categorySalary,
      iconColor: Color(0xFF2E7D32),
      period: 'Monthly',
    ),
    _TransactionItem(
      title: 'Entertainment',
      subtitle: 'Card',
      amount: -8,
      date: 'Mar 07, 2023',
      icon: Icons.confirmation_number,
      backgroundColor: AppColors.categoryEntertainment,
      iconColor: Color(0xFF6A1B9A),
      period: 'Weekly',
    ),
    _TransactionItem(
      title: 'Fuel',
      subtitle: 'Cash',
      amount: -45,
      date: 'Mar 06, 2023',
      icon: Icons.directions_car,
      backgroundColor: AppColors.categoryFuel,
      iconColor: Color(0xFFEF6C00),
      period: 'Daily',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _transactions
        .where(
          (item) => _selectedFilter == 'All' || item.period == _selectedFilter,
        )
        .toList();

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
                  _RecentTransactions(items: filteredTransactions),
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

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
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
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BalanceLine(
                      color: AppColors.primaryBlue,
                      label: 'Income',
                      value: '\$8,429',
                    ),
                    SizedBox(height: AppSpacing.lg),
                    _BalanceLine(
                      color: AppColors.accentBlue,
                      label: 'Spent',
                      value: '\$3,621',
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              _BalanceProgress(),
            ],
          ),
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
  @override
  Widget build(BuildContext context) {
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
                  AppColors.primaryBlue,
                  AppColors.primaryBlue,
                  AppColors.accentBlue,
                ],
                stops: const [0.0, 0.7, 1.0],
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

class _RecentTransactions extends StatelessWidget {
  final List<_TransactionItem> items;

  const _RecentTransactions({required this.items});

  @override
  Widget build(BuildContext context) {
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
        Column(
          children: items
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(
                    bottom: item == items.last ? 0 : AppSpacing.md,
                  ),
                  child: _TransactionTile(item: item),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final _TransactionItem item;

  const _TransactionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final amountText = item.amount >= 0
        ? '+\$${item.amount.toStringAsFixed(0)}'
        : '-\$${item.amount.abs().toStringAsFixed(0)}';
    final amountColor = item.amount >= 0
        ? AppColors.incomeGreen
        : AppColors.expenseRed;

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
              color: item.backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: item.iconColor),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  item.subtitle,
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
                item.date,
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

class _TransactionItem {
  final String title;
  final String subtitle;
  final double amount;
  final String date;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final String period;

  const _TransactionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.period,
  });
}
