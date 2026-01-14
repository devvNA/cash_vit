import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login with validation
/// Encapsulates business logic and rules
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Execute login with validation
  /// 
  /// Validation rules:
  /// - Username: required, min 3 characters
  /// - Password: required, min 6 characters
  /// 
  /// Returns [AuthEntity] on success
  /// Throws [Exception] with validation message on failure
  Future<AuthEntity> call({
    required String username,
    required String password,
  }) async {
    // Validation
    if (username.isEmpty) {
      throw Exception('Username is required');
    }

    if (password.isEmpty) {
      throw Exception('Password is required');
    }

    if (username.length < 3) {
      throw Exception('Username must be at least 3 characters');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Call repository
    return await repository.login(
      username: username,
      password: password,
    );
  }
}
