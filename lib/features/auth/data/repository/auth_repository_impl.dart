import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of [AuthRepository] interface
/// Coordinates between remote datasource and in-memory storage
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  // In-memory storage (data hilang saat app restart)
  AuthEntity? _currentAuth;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<AuthEntity> login({
    required String username,
    required String password,
  }) async {
    // Call remote datasource
    final model = await remoteDatasource.login(
      username: username,
      password: password,
    );

    // Save to in-memory storage
    _currentAuth = model.toEntity();

    // Return domain entity
    return _currentAuth!;
  }

  @override
  Future<void> logout() async {
    // Clear in-memory storage
    _currentAuth = null;
  }

  @override
  Future<AuthEntity?> getCurrentAuth() async {
    // Return current in-memory auth
    return _currentAuth;
  }
}
