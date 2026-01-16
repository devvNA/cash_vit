import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/auth/presentation/providers/auth_provider.dart';
import 'package:cash_vit/features/home_dashboard/presentation/providers/transaction_provider.dart';
import 'package:cash_vit/features/profile/presentation/providers/profile_provider.dart';
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
                    const _Header(),
                    SizedBox(height: AppSpacing.lg),
                    _ProfileInfo(profile: profile),
                    SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Income',
                            value: totalIncome.toRupiah,
                            backgroundColor: Color(0x1A2196F3),
                            valueColor: AppColors.primaryBlue,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            label: 'Spent',
                            value: totalExpense.toRupiah,
                            backgroundColor: Color(0x1AF44336),
                            valueColor: AppColors.expenseRed,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xl + AppSpacing.sm),
                    const _SectionTitle('General'),
                    const _ProfileTile(
                      icon: Icons.person,
                      title: 'Personal Information',
                      subtitle: 'Name, Date of Birth, etc.',
                      iconBackground: Color(0xFFE3F2FD),
                      iconColor: AppColors.primaryBlue,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    const _ProfileTile(
                      icon: Icons.credit_card,
                      title: 'Payment Methods',
                      subtitle: 'Visa **42',
                      iconBackground: Color(0xFFE3F2FD),
                      iconColor: AppColors.primaryBlue,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    const _ProfileTile(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      subtitle: 'App alerts, Email settings',
                      iconBackground: Color(0xFFE3F2FD),
                      iconColor: AppColors.primaryBlue,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    _LogoutButton(onPressed: () => _onLogout(context)),
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: SizedBox.shrink()),
        Expanded(
          child: Text(
            'Profile',
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _RoundIconButton(icon: Icons.settings, onPressed: () {}),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _RoundIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: AppRadius.mediumRadius,
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
        icon: Icon(icon, size: 22),
        color: AppColors.textPrimary,
        onPressed: onPressed,
        splashRadius: 24,
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final dynamic profile;

  const _ProfileInfo({required this.profile});

  @override
  Widget build(BuildContext context) {
    // Extract name
    final firstName = profile.name?.firstname ?? 'User';
    final lastName = profile.name?.lastname ?? '';
    final fullName = '$firstName $lastName'.trim();
    final email = profile.email ?? 'No email';
    final username = profile.username ?? '';

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backgroundLight,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Container(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    child: Center(
                      child: Text(
                        firstName[0],
                        style: AppTypography.display.copyWith(
                          color: AppColors.surfaceWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backgroundLight,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                  splashRadius: 20,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        Text(fullName, style: AppTypography.headline4),
        SizedBox(height: AppSpacing.xs),
        Text(
          email,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (username.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            '@$username',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color backgroundColor;
  final Color valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.largeRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.headline5.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(title, style: AppTypography.headline5),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBackground;
  final Color iconColor;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBackground,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: AppRadius.cardRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LogoutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        side: BorderSide(color: AppColors.expenseRed.withValues(alpha: 0.3)),
        foregroundColor: AppColors.expenseRed,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
      ),
      icon: const Icon(Icons.logout, size: 20),
      label: Text(
        'Log Out',
        style: AppTypography.buttonMedium.copyWith(color: AppColors.expenseRed),
      ),
    );
  }
}
