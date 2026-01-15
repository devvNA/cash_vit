class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://fakestoreapi.com';

  // Auth Endpoints
  static const String loginEndpoint = '/auth/login';

  // User Endpoints
  static String userDetailEndpoint(int userId) => '/users/$userId';

  // Timeouts
  static const int connectTimeout = 20000; // 20 seconds
  static const int receiveTimeout = 20000; // 20 seconds
  static const int sendTimeout = 20000; // 20 seconds
}
