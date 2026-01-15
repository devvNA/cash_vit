class ProfileEntity {
  ProfileEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.phone,
  });

  final int? id;
  final String? email;
  final String? username;
  final String? password;
  final Name? name;
  final String? phone;
}

class Name {
  Name({required this.firstname, required this.lastname});

  final String? firstname;
  final String? lastname;
}
