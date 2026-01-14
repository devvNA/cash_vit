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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthEntity &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          userId == other.userId &&
          expiresAt == other.expiresAt;

  @override
  int get hashCode => token.hashCode ^ userId.hashCode ^ expiresAt.hashCode;

  @override
  String toString() =>
      'AuthEntity(token: $token, userId: $userId, expiresAt: $expiresAt)';
}
