import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/home_dashboard/presentation/widgets/filter_chips.dart';
import 'package:cash_vit/features/home_dashboard/presentation/widgets/home_balance_card.dart';
import 'package:cash_vit/features/home_dashboard/presentation/widgets/home_header.dart';
import 'package:cash_vit/features/home_dashboard/presentation/widgets/recent_transactions_list.dart';
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
                  const HomeHeader(),
                  SizedBox(height: AppSpacing.lg),
                  FilterChips(
                    filters: _filters,
                    selected: _selectedFilter,
                    onSelect: (value) =>
                        setState(() => _selectedFilter = value),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  const HomeBalanceCard(),
                  SizedBox(height: AppSpacing.xl),
                  RecentTransactionsList(filter: _selectedFilter),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
