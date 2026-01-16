import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/auth/presentation/providers/auth_provider.dart';
import 'package:cash_vit/features/auth/presentation/widgets/index.dart';
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

  Widget _buildPasswordToggle(bool isLoading) {
    return Padding(
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
                      const LoginHeader(),
                      SizedBox(height: AppSpacing.xl + AppSpacing.lg),

                      // --- Form Area ---
                      LoginTextField(
                        fieldHeight: 56,
                        controller: _usernameController,
                        label: 'Username',
                        hintText: 'johnd',
                        prefixIcon: Icons.person_outline_rounded,
                        isEnabled: !isLoading,
                      ),
                      SizedBox(height: AppSpacing.paddingCard),
                      LoginTextField(
                        fieldHeight: 56,
                        controller: _passwordController,
                        label: 'Password',
                        hintText: '******',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: !_isPasswordVisible,
                        isEnabled: !isLoading,
                        suffixIcon: _buildPasswordToggle(isLoading),
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Forgot Password
                      ForgotPasswordLink(onPressed: isLoading ? null : () {}),
                      SizedBox(height: AppSpacing.xxl),

                      // Login Button
                      LoginButton(
                        onPressed: isLoading ? null : _handleLogin,
                        isLoading: isLoading,
                      ),

                      // --- Sign Up Link ---
                      SizedBox(height: AppSpacing.xl + AppSpacing.lg),
                      SignUpLink(onPressed: isLoading ? null : () {}),
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
}
