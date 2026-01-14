import 'package:cash_vit/features/auth/data/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Sealed class representing all possible authentication states
/// Following TECHNICAL_OVERVIEW.md pattern for type-safe state management
sealed class AuthState {
  const AuthState();
}

/// Initial state when app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during authentication process
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state with token
class AuthAuthenticated extends AuthState {
  final String token;

  const AuthAuthenticated(this.token);
}

/// Unauthenticated state (no token)
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state with message
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

/// Auth repository provider (dependency injection)
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}

/// Auth notifier managing authentication state
/// Following TECHNICAL_OVERVIEW.md Riverpod pattern
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Check saved auth status on init (future implementation)
    // For now, start as unauthenticated
    return const AuthUnauthenticated();
  }

  /// Login with username and password
  Future<void> login({
    required String username,
    required String password,
  }) async {
    // Validation
    if (username.isEmpty || password.isEmpty) {
      state = const AuthError('Username and password cannot be empty');
      _autoResetError();
      return;
    }

    // Set loading state
    state = const AuthLoading();

    try {
      // Get repository from provider
      final repository = ref.read(authRepositoryProvider);

      // Call API
      final token = await repository.login(
        username: username,
        password: password,
      );

      // Success - update to authenticated state
      state = AuthAuthenticated(token);
    } catch (e) {
      // Error - update to error state
      state = AuthError(e.toString().replaceFirst('Exception: ', ''));
      _autoResetError();
    }
  }

  /// Logout user
  Future<void> logout() async {
    state = const AuthLoading();

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();

      // Success - back to unauthenticated
      state = const AuthUnauthenticated();
    } catch (e) {
      // Even on error, logout locally
      state = const AuthUnauthenticated();
    }
  }

  /// Auto-reset error state after 3 seconds
  /// Following TECHNICAL_OVERVIEW.md error recovery pattern
  void _autoResetError() {
    Future.delayed(const Duration(seconds: 3), () {
      if (state is AuthError) {
        state = const AuthUnauthenticated();
      }
    });
  }
}
