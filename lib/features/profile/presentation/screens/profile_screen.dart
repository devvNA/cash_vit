import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/auth/presentation/providers/auth_provider.dart';
import 'package:cash_vit/features/home_dashboard/presentation/providers/transaction_provider.dart';
import 'package:cash_vit/features/profile/presentation/providers/profile_provider.dart';
import 'package:cash_vit/features/profile/presentation/widgets/logout_button.dart';
import 'package:cash_vit/features/profile/presentation/widgets/profile_avatar_info.dart';
import 'package:cash_vit/features/profile/presentation/widgets/profile_header.dart';
import 'package:cash_vit/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:cash_vit/features/profile/presentation/widgets/profile_section_title.dart';
import 'package:cash_vit/features/profile/presentation/widgets/profile_stat_card.dart';
import 'package:cash_vit/features/splash_screen/presentation/screens/splash_screen.dart';
import 'package:cash_vit/shared/extensions/currency_extension.dart';
import 'package:cash_vit/shared/widgets/background_glows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile on screen init with userId = 1
    Future.microtask(() {
      ref.read(profileProvider.notifier).fetchProfile(userId: 1);
    });
  }

  void _onLogout(BuildContext context) {
    ref.read(authProvider.notifier).logout();
    // Clear all routes and navigate to SplashScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    // Listen for errors
    ref.listen<ProfileState>(profileProvider, (previous, next) {
      if (next is ProfileError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.expenseRed,
          ),
        );
      }
    });

    final state = ref.watch(transactionProvider);

    double totalIncome = 0;
    double totalExpense = 0;

    if (state is TransactionLoaded) {
      totalIncome = state.totalIncome;
      totalExpense = state.totalExpense;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundGlows(),
            switch (profileState) {
              ProfileInitial() || ProfileLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              ProfileError() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.expenseRed,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Text(
                      'Failed to load profile',
                      style: AppTypography.headline2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(profileProvider.notifier)
                            .fetchProfile(userId: 1);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              ProfileLoaded(profile: final profile) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingScreen,
                ).copyWith(top: AppSpacing.lg, bottom: AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ProfileHeader(),
                    SizedBox(height: AppSpacing.lg),
                    ProfileAvatarInfo(profile: profile),
                    SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: ProfileStatCard(
                            label: 'Income',
                            value: totalIncome.toRupiah,
                            backgroundColor: const Color(0x1A2196F3),
                            valueColor: AppColors.primaryBlue,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: ProfileStatCard(
                            label: 'Spent',
                            value: totalExpense.toRupiah,
                            backgroundColor: const Color(0x1AF44336),
                            valueColor: AppColors.expenseRed,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xl + AppSpacing.sm),
                    const ProfileSectionTitle('General'),
                    const ProfileMenuTile(
                      icon: Icons.person,
                      title: 'Personal Information',
                      subtitle: 'Name, Date of Birth, etc.',
                      iconBackground: Color(0xFFE3F2FD),
                      iconColor: AppColors.primaryBlue,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    const ProfileMenuTile(
                      icon: Icons.credit_card,
                      title: 'Payment Methods',
                      subtitle: 'Visa **42',
                      iconBackground: Color(0xFFE3F2FD),
                      iconColor: AppColors.primaryBlue,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    const ProfileMenuTile(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      subtitle: 'App alerts, Email settings',
                      iconBackground: Color(0xFFE3F2FD),
                      iconColor: AppColors.primaryBlue,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    LogoutButton(onPressed: () => _onLogout(context)),
                  ],
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}
