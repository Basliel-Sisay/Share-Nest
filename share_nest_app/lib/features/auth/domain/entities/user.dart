enum UserRole { regularUser, resourceOwner }

extension UserRoleX on UserRole {
  String get value {
    switch (this) {
      case UserRole.regularUser:
        return 'regular_user';
      case UserRole.resourceOwner:
        return 'resource_owner';
    }
  }

  static UserRole fromString(String role) {
    switch (role) {
      case 'resource_owner':
        return UserRole.resourceOwner;
      default:
        return UserRole.regularUser;
    }
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  bool get isResourceOwner => role == UserRole.resourceOwner;

  bool canManageResource(String ownerId) => id == ownerId || isResourceOwner;
  bool canApproveRequests() => isResourceOwner;
  bool canCreateResource() => true;
  bool canSubmitLoan() => true;
  bool canCreateReservation() => true;
}
