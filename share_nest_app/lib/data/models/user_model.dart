import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
  @JsonValue('regular_user')
  regularUser,

  @JsonValue('resource_owner')
  resourceOwner,
}

extension UserRoleX on UserRole {
  bool get isOwner => this == UserRole.resourceOwner;
  bool get isRegular => this == UserRole.regularUser;

  String get displayName =>
      this == UserRole.resourceOwner ? 'Resource Owner' : 'Regular User';
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    required UserRole role,
    String? accessToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}