import 'package:cash_vit/core/constants/api_constants.dart';
import 'package:cash_vit/core/services/api_services.dart';
import 'package:cash_vit/features/profile/data/models/user_response_model.dart';
import 'package:dio/dio.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResponseModel> getProfile({required int userId});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiRequest apiRequest;

  ProfileRemoteDataSourceImpl({required this.apiRequest});

  @override
  Future<ProfileResponseModel> getProfile({required int userId}) async {
    try {
      final response = await apiRequest.get(
        ApiConstants.userDetailEndpoint(userId),
      );
      if (response.statusCode == 200) {
        return ProfileResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get profile');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to get profile: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }
}
