import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

/// Implementation of [ProfileRepository] interface
/// Coordinates between remote datasource and domain layer
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDatasource;

  ProfileRepositoryImpl({required this.remoteDatasource});

  @override
  Future<ProfileEntity> getProfile({required int userId}) async {
    // Call remote datasource
    final model = await remoteDatasource.getProfile(userId: userId);

    // Return domain entity
    return model.toEntity();
  }
}
