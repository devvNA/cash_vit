import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/auth/presentation/providers/auth_provider.dart';
import 'package:cash_vit/features/base/presentation/screens/base_screen.dart';
import 'package:cash_vit/shared/widgets/background_glows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController(text: 'johnd');
  final _passwordController = TextEditingController(text: 'm38rmF\$');
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Trigger login via Riverpod provider
    // Following TECHNICAL_OVERVIEW.md ref.read() pattern for actions
    ref
        .read(authProvider.notifier)
        .login(
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state for UI updates
    // Following TECHNICAL_OVERVIEW.md ref.watch() pattern
    final authState = ref.watch(authProvider);

    // Listen for side effects (errors, success)
    // Following TECHNICAL_OVERVIEW.md ref.listen() pattern
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.expenseRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      if (next is AuthAuthenticated) {
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BaseScreen()),
        );
      }
    });

    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Background Ambient Blobs
            const BackgroundGlows(),

            // 2. Main Content
            Center(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Header Area ---
                      const _LoginHeader(),
                      SizedBox(height: AppSpacing.xl + AppSpacing.lg),

                      // --- Form Area ---
                      _buildUsernameField(isLoading),
                      SizedBox(height: AppSpacing.paddingCard),
                      _buildPasswordField(isLoading),
                      SizedBox(height: AppSpacing.md),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading ? null : () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: AppColors.primaryBlueDark,
                          ),
                          child: Text(
                            'Forgot password?',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxl),

                      // Login Button
                      _LoginButton(
                        onPressed: isLoading ? null : _handleLogin,
                        isLoading: isLoading,
                      ),

                      // --- Sign Up Link ---
                      SizedBox(height: AppSpacing.xl + AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: isLoading ? null : () {},
                            child: Text(
                              'Sign up now',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameField(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(
            'Username',
            style: AppTypography.caption.copyWith(color: AppColors.textPrimary),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _usernameController,
            enabled: !isLoading,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: 'johnd',
              hintStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              prefixIcon: const Icon(
                size: 20,
                Icons.person_outline_rounded,
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  color: AppColors.primaryBlue,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              filled: true,
              fillColor: AppColors.surfaceWhite,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(
            'Password',
            style: AppTypography.headline3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _passwordController,
            enabled: !isLoading,
            obscureText: !_isPasswordVisible,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: '******',
              hintStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(
                    size: 24,
                    _isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  color: AppColors.primaryBlue,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              filled: true,
              fillColor: AppColors.surfaceWhite,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo Container
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: AppRadius.cardRadius,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        SizedBox(height: AppSpacing.xl),
        Text(
          'Welcome Back',
          style: AppTypography.headline3.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Please enter your details to sign in',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _LoginButton({required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: isLoading
            ? LinearGradient(
                colors: [
                  AppColors.primaryBlue.withValues(alpha: 0.5),
                  AppColors.primaryBlueDark.withValues(alpha: 0.5),
                ],
              )
            : AppColors.primaryGradient,
        borderRadius: AppRadius.largeRadius,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                'Sign in',
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
