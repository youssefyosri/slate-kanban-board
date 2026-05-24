enum UserRole {
  admin,
  user,
  guest,
}

extension UserRoleX on UserRole {
  bool get isAdmin => this == UserRole.admin;

  static UserRole fromString(String? roleStr) {
    return UserRole.values.firstWhere(
          (e) => e.name == roleStr,
      orElse: () => UserRole.guest,
    );
  }
}