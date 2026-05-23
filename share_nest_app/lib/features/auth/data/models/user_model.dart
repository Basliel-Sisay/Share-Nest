class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
  });

  final String id;
  final String name;
  final String email;
  final String? token;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'token': token ?? '',
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      token: (map['token'] as String?)?.isNotEmpty == true
          ? map['token'] as String
          : null,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  UserModel copyWith({String? token}) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      token: token ?? this.token,
    );
  }
}
