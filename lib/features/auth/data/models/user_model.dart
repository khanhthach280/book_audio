import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// User model for data layer
@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.avatar,
    super.phoneNumber,
    super.dateOfBirth,
    super.createdAt,
    super.updatedAt,
  });
  
  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  
  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  /// Create UserModel from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      avatar: user.avatar,
      phoneNumber: user.phoneNumber,
      dateOfBirth: user.dateOfBirth,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
  
  /// Convert UserModel to User entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
