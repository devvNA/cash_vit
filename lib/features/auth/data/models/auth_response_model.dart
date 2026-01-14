import '../../domain/entities/auth_entity.dart';

/// Data Transfer Object (DTO) for authentication API response
/// Extends [AuthEntity] and adds JSON serialization
class AuthResponseModel extends AuthEntity {
  const AuthResponseModel({
    required super.token,
    required super.userId,
    required super.expiresAt,
  });

  /// Create model from JSON response
  /// FakeStore API returns: {"token": "..."}
  /// We generate userId and expiresAt since API doesn't provide them
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] as String,
      userId: json['userId'] as int? ?? 1, // Default to 1 if not provided
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  /// Convert model to domain entity
  AuthEntity toEntity() {
    return AuthEntity(
      token: token,
      userId: userId,
      expiresAt: expiresAt,
    );
  }
}
