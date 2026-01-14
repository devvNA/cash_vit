import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/base/widgets/custom_bottom_nav.dart';
import 'package:cash_vit/features/home_dashboard/presentation/screens/home_dashboard_screen.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [HomeDashboardScreen(), const Placeholder()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlueDark,
        onPressed: () {
          // TODO: Navigate to ExpenseFormScreen
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
