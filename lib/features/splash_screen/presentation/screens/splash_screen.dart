import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/auth/presentation/screens/login_screen.dart';
import 'package:cash_vit/features/splash_screen/presentation/providers/splash_provider.dart';
import 'package:cash_vit/shared/widgets/background_glows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SplashState>(splashProvider, (previous, next) {
      if (next is SplashComplete) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });

    // Watch state for UI updates
    final splashState = ref.watch(splashProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // 1. Decorative Background Elements (Glows)
          const BackgroundGlows(),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(), // Push content to center and footer to bottom
                // Center Content: Logo & Brand
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Container
                      const _LogoBrand(),
                      SizedBox(height: AppSpacing.xxl),

                      // Brand Name
                      Text(
                        'CashVit',
                        style: AppTypography.textTheme.displayLarge?.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Tagline
                      Text(
                        'TRACK. SAVE. GROW.',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Footer Content: Loading & Info
                // Extract progress from state using pattern matching
                _FooterContent(
                  progress: splashState is SplashLoading
                      ? splashState.progress
                      : 0.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoBrand extends StatelessWidget {
  const _LogoBrand();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.xxl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.account_balance_wallet_rounded,
        size: 64,
        color: Colors.white,
      ),
    );
  }
}

class _FooterContent extends StatelessWidget {
  final double progress;

  const _FooterContent({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.paddingScreen,
        0,
        AppSpacing.paddingScreen,
        64,
      ),
      child: Column(
        children: [
          // Minimalist Loading Bar
          Center(
            child: Column(
              children: [
                // Loading Bar Background
                Container(
                  height: 5,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                // Footer Text
                Text(
                  'By Devit Nur Azaqi',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'v1.0.0',
                  style: AppTypography.textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
