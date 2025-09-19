import 'package:equatable/equatable.dart';

/// User entity representing a user in the system
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phoneNumber,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });
  
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  @override
  List<Object?> get props => [
    id,
    email,
    name,
    avatar,
    phoneNumber,
    dateOfBirth,
    createdAt,
    updatedAt,
  ];
  
  /// Create a copy of this user with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phoneNumber,
    DateTime? dateOfBirth,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
  
  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
