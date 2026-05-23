import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password = '',
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'regular_user',
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromDb(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String? ?? '',
      role: map['role'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'createdAt': createdAt,
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      role: UserRoleX.fromString(role),
      createdAt: DateTime.parse(createdAt),
    );
  }

  factory UserModel.fromEntity(User user, {String password = ''}) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: password,
      role: user.role.value,
      createdAt: user.createdAt.toIso8601String(),
    );
  }

  UserModel copyWith({String? password}) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      password: password ?? this.password,
      role: role,
      createdAt: createdAt,
    );
  }
}
