import 'package:cash_vit/core/constants/api_constants.dart';
import 'package:cash_vit/core/services/api_services.dart';
import 'package:dio/dio.dart';

import '../models/auth_response_model.dart';

/// Abstract datasource interface for authentication remote operations
abstract class AuthRemoteDatasource {
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  });
}

/// Implementation of [AuthRemoteDatasource] using FakeStore API
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiRequest apiRequest;

  AuthRemoteDatasourceImpl({required this.apiRequest});

  @override
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await apiRequest.post(
        ApiConstants.loginEndpoint,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Login failed: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
