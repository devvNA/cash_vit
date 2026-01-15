import 'package:cash_vit/features/profile/domain/entities/profile_entity.dart';

class ProfileResponseModel extends ProfileEntity {
  ProfileResponseModel({
    required super.id,
    required super.email,
    required super.username,
    required super.password,
    required super.name,
    required super.phone,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    // Parse name object
    Name? parsedName;
    if (json['name'] != null && json['name'] is Map) {
      final nameMap = json['name'] as Map<String, dynamic>;
      parsedName = Name(
        firstname: nameMap['firstname'] as String?,
        lastname: nameMap['lastname'] as String?,
      );
    }

    return ProfileResponseModel(
      id: json['id'] as int?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      name: parsedName,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'name': name != null
          ? {
              'firstname': name!.firstname,
              'lastname': name!.lastname,
            }
          : null,
      'phone': phone,
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      email: email,
      username: username,
      password: password,
      name: name,
      phone: phone,
    );
  }
}
