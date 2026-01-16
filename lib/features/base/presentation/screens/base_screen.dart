import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/add_transaction/presentation/screens/add_transaction_screen.dart';
import 'package:cash_vit/features/base/presentation/widgets/custom_bottom_nav.dart';
import 'package:cash_vit/features/home_dashboard/presentation/screens/home_dashboard_screen.dart';
import 'package:cash_vit/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  final List<Widget> _screens = [HomeDashboardScreen(), const ProfileScreen()];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onFabPressed() async {
    // Scale down animation
    await _fabAnimationController.forward();
    // Scale back up
    await _fabAnimationController.reverse();

    if (!mounted) return;

    // Navigate with slide transition from bottom
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const AddTransactionScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton(
          backgroundColor: AppColors.primaryBlueDark,
          onPressed: _onFabPressed,
          child: const Icon(Icons.add),
        ),
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
