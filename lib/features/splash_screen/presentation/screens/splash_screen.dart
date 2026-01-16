import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/auth/presentation/screens/login_screen.dart';
import 'package:cash_vit/features/splash_screen/presentation/providers/splash_provider.dart';
import 'package:cash_vit/features/splash_screen/presentation/widgets/footer_content.dart';
import 'package:cash_vit/features/splash_screen/presentation/widgets/logo_brand.dart';
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
                      const LogoBrand(),
                      SizedBox(height: AppSpacing.xxl),

                      // Brand Name
                      Text(
                        'CashVit',
                        style: AppTypography.headline1.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Tagline
                      Text(
                        'TRACK. SAVE. GROW.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
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
                FooterContent(
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
