import '../repositories/auth_repository.dart';

/// Use case for user logout
/// Encapsulates logout business logic
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Execute logout
  /// Clears authentication data from storage
  Future<void> call() async {
    await repository.logout();
  }
}
