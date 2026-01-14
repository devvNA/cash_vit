import 'package:cash_vit/core/services/local_storage_services.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of [AuthRepository] interface
/// Coordinates between remote datasource and local storage
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

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

    // Save to local storage
    await LocalStorageService().saveAuthToken(model.token);
    await LocalStorageService().setInt('user_id', model.userId);
    await LocalStorageService().setLoggedIn(true);

    // Return domain entity
    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    // Clear local storage
    await LocalStorageService().logout();
  }

  @override
  Future<AuthEntity?> getCurrentAuth() async {
    // Check if user is logged in
    final isLoggedIn = LocalStorageService().isLoggedIn();
    if (!isLoggedIn) return null;

    // Get saved token
    final token = LocalStorageService().getAuthToken();
    if (token == null) return null;

    // Get saved user ID
    final userId = LocalStorageService().getInt('user_id') ?? 0;

    // Return entity
    return AuthEntity(
      token: token,
      userId: userId,
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }
}
