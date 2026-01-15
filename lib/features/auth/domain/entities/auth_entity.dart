/// Domain entity representing authentication data
/// Pure business object with no external dependencies
class AuthEntity {
  final String token;
  final int userId;
  final DateTime expiresAt;

  const AuthEntity({
    required this.token,
    required this.userId,
    required this.expiresAt,
  });

  @override
  String toString() =>
      'AuthEntity(token: $token, userId: $userId, expiresAt: $expiresAt)';
}
