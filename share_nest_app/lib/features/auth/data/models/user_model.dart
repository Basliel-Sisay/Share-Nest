class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    this.token,
    this.imagePath,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String? token;
  final String? imagePath;

  bool get isOwner => role == 'owner';

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'token': token ?? '',
        'imagePath': imagePath ?? '',
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      role: (map['role'] as String?) ?? 'user',
      token: (map['token'] as String?)?.isNotEmpty == true
          ? map['token'] as String
          : null,
      imagePath: (map['imagePath'] as String?)?.isNotEmpty == true
          ? map['imagePath'] as String
          : null,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: (json['role'] as String?) ?? 'user',
      imagePath: json['imagePath'] as String?,
    );
  }

  UserModel copyWith({String? token, String? role, String? imagePath}) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      role: role ?? this.role,
      token: token ?? this.token,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
