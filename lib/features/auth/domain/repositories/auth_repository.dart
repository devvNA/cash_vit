import '../entities/auth_entity.dart';

/// Abstract repository interface defining authentication operations
/// This is the contract that data layer must implement
abstract class AuthRepository {
  /// Login with username and password
  /// Returns [AuthEntity] on success
  /// Throws [Exception] on failure
  Future<AuthEntity> login({
    required String username,
    required String password,
  });

  /// Logout current user
  /// Clears authentication data from storage
  Future<void> logout();

  /// Get currently saved authentication data
  /// Returns [AuthEntity] if token exists, null otherwise
  Future<AuthEntity?> getCurrentAuth();
}
