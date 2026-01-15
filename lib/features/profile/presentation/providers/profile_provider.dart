import 'package:cash_vit/core/services/api_services.dart';
import 'package:cash_vit/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:cash_vit/features/profile/data/repository/profile_repository_impl.dart';
import 'package:cash_vit/features/profile/domain/entities/profile_entity.dart';
import 'package:cash_vit/features/profile/domain/repositories/profile_repository.dart';
import 'package:cash_vit/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

/// Sealed class representing all possible profile states
sealed class ProfileState {
  const ProfileState();
}

/// Initial state when screen loads
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Loading state during profile fetch
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Loaded state with profile data
class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded(this.profile);
}

/// Error state with message
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);
}

// ==================== Dependency Injection ====================

/// Remote datasource provider
@riverpod
ProfileRemoteDataSource profileRemoteDatasource(Ref ref) {
  return ProfileRemoteDataSourceImpl(apiRequest: ApiRequest());
}

/// Profile repository provider (implements domain interface)
@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(
    remoteDatasource: ref.watch(profileRemoteDatasourceProvider),
  );
}

/// Get profile use case provider
@riverpod
GetProfileUseCase getProfileUseCase(Ref ref) {
  return GetProfileUseCase(ref.watch(profileRepositoryProvider));
}

/// Profile notifier managing profile state
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  ProfileState build() {
    return const ProfileInitial();
  }

  /// Fetch user profile by userId
  Future<void> fetchProfile({required int userId}) async {
    // Set loading state
    state = const ProfileLoading();

    try {
      // Get use case and execute
      final useCase = ref.read(getProfileUseCaseProvider);
      final profile = await useCase(userId: userId);

      // Success - update to loaded state
      state = ProfileLoaded(profile);
    } catch (e) {
      // Error - update to error state
      state = ProfileError(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
