import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String role;
  final String department;
  final String designation;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.role,
    required this.department,
    required this.designation,
  });

  @override
  List<Object?> get props => [id, email, name, photoUrl, role, department, designation];

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? role,
    String? department,
    String? designation,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      department: department ?? this.department,
      designation: designation ?? this.designation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'role': role,
      'department': department,
      'designation': designation,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String,
      department: json['department'] as String,
      designation: json['designation'] as String,
    );
  }
}
