class User {
  final int id;
  final String username;
  final String email;
  final String name;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
  });

  /// Factory constructor untuk parse dari JSON (API response)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      name: json['name'] is Map
          ? (json['name'] as Map)['firstname'] ?? ''
          : json['name'] as String,
    );
  }

  /// Convert ke JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'email': email, 'name': name};
  }

  /// Copy with untuk immutability
  User copyWith({int? id, String? username, String? email, String? name}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }

  @override
  String toString() =>
      'User(id: $id, username: $username, email: $email, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          email == other.email &&
          name == other.name;

  @override
  int get hashCode =>
      id.hashCode ^ username.hashCode ^ email.hashCode ^ name.hashCode;
}
