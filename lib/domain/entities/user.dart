// lib/domain/entities/user.dart
import 'package:equatable/equatable.dart';

/// Base User entity
class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatar;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
    this.isEmailVerified = false,
    this.createdAt,
    this.lastLoginAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    avatar,
    isEmailVerified,
    createdAt,
    lastLoginAt,
  ];
}

/// Authenticated User with tokens
class AuthUser extends User {
  final String accessToken;
  final String refreshToken;

  const AuthUser({
    required super.id,
    required super.email,
    super.name,
    super.avatar,
    super.isEmailVerified,
    super.createdAt,
    super.lastLoginAt,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  AuthUser copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => [...super.props, accessToken, refreshToken];
}
