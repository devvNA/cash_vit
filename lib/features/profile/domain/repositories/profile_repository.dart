import '../entities/profile_entity.dart';

/// Abstract repository interface defining profile operations
/// This is the contract that data layer must implement
abstract class ProfileRepository {
  /// Get user profile by user ID
  /// Returns [ProfileEntity] on success
  /// Throws [Exception] on failure
  Future<ProfileEntity> getProfile({required int userId});
}
