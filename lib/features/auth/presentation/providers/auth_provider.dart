import 'package:cash_vit/core/services/api_services.dart';
import 'package:cash_vit/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cash_vit/features/auth/data/repository/auth_repository_impl.dart';
import 'package:cash_vit/features/auth/domain/repositories/auth_repository.dart';
import 'package:cash_vit/features/auth/domain/usecases/login_usecase.dart';
import 'package:cash_vit/features/auth/domain/usecases/logout_usecase.dart';
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

// ==================== Dependency Injection ====================

/// Remote datasource provider
@riverpod
AuthRemoteDatasource authRemoteDatasource(Ref ref) {
  return AuthRemoteDatasourceImpl(apiRequest: ApiRequest());
}

/// Auth repository provider (implements domain interface)
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDatasource: ref.watch(authRemoteDatasourceProvider),
  );
}

/// Login use case provider
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

/// Logout use case provider
@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}

/// Auth notifier managing authentication state
/// Following TECHNICAL_OVERVIEW.md Riverpod pattern
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Check saved auth status on initialization
    _checkSavedAuth();
    return const AuthInitial();
  }

  /// Login with username and password
  /// Uses [LoginUseCase] which includes validation
  Future<void> login({
    required String username,
    required String password,
  }) async {
    // Set loading state
    state = const AuthLoading();

    try {
      // Get use case and execute
      final useCase = ref.read(loginUseCaseProvider);
      final authEntity = await useCase(
        username: username,
        password: password,
      );

      // Success - update to authenticated state
      state = AuthAuthenticated(authEntity.token);
    } catch (e) {
      // Error - update to error state
      state = AuthError(e.toString().replaceFirst('Exception: ', ''));
      _autoResetError();
    }
  }

  /// Logout user
  /// Uses [LogoutUseCase]
  Future<void> logout() async {
    state = const AuthLoading();

    try {
      // Get use case and execute
      final useCase = ref.read(logoutUseCaseProvider);
      await useCase();

      // Success - back to unauthenticated
      state = const AuthUnauthenticated();
    } catch (e) {
      // Even on error, logout locally
      state = const AuthUnauthenticated();
    }
  }

  /// Check if user has saved authentication
  /// Called on app startup
  Future<void> _checkSavedAuth() async {
    final repository = ref.read(authRepositoryProvider);
    final auth = await repository.getCurrentAuth();

    if (auth != null) {
      state = AuthAuthenticated(auth.token);
    } else {
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
