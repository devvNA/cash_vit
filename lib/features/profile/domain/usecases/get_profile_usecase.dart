import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Use case for getting user profile
/// Encapsulates business logic and validation
class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  /// Validation rules:
  /// 
  /// Returns [ProfileEntity] on success
  /// Throws [Exception] with validation message on failure
  Future<ProfileEntity> call({required int userId}) async {
    // Validation
    if (userId <= 0) {
      throw Exception('Invalid user ID');
    }

    // Call repository
    return await repository.getProfile(userId: userId);
  }
}
