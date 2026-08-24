// lib/data/models/auth/user_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? avatar;
  @JsonKey(name: 'isEmailVerified')
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
    this.isEmailVerified = false,
    this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toDomain() {
    return User(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
    );
  }

  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      avatar: user.avatar,
      isEmailVerified: user.isEmailVerified,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
    );
  }
}

@JsonSerializable()
class AuthUserModel {
  final UserModel user;
  @JsonKey(name: 'accessToken')
  final String accessToken;
  @JsonKey(name: 'refreshToken')
  final String refreshToken;

  AuthUserModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  AuthUser toDomain() {
    return AuthUser(
      id: user.id,
      email: user.email,
      name: user.name,
      avatar: user.avatar,
      isEmailVerified: user.isEmailVerified,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  factory AuthUserModel.fromDomain(AuthUser user) {
    return AuthUserModel(
      user: UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        avatar: user.avatar,
        isEmailVerified: user.isEmailVerified,
        createdAt: user.createdAt,
        lastLoginAt: user.lastLoginAt,
      ),
      accessToken: user.accessToken,
      refreshToken: user.refreshToken,
    );
  }
}
