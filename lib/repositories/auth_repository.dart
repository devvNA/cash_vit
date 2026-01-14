import 'package:cash_vit/utils/services/api_services.dart';
import 'package:dio/dio.dart';

/// Repository handling authentication API calls
/// Following TECHNICAL_OVERVIEW.md repository pattern
class AuthRepository {
  final ApiRequest _apiRequest;

  AuthRepository({ApiRequest? apiRequest})
    : _apiRequest = apiRequest ?? ApiRequest();

  /// Login with username and password
  ///
  /// Endpoint: POST /auth/login
  /// Body: {"username": "...", "password": "..."}
  /// Returns: {"token": "..."}
  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiRequest.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final token = data['token'] as String;
        return token;
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Login failed: ${e.response?.statusMessage}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Logout (clear local storage)
  /// FakeStore API doesn't have real logout, so this just simulates it
  Future<void> logout() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app: clear token from secure storage
  }
}
