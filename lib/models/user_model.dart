import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  @HiveField(3) // New field for admin role
  final bool isAdmin;

  User({
    required this.fullName,
    required this.email,
    required this.password,
    this.isAdmin = false, // Default is false for regular users
  });
}
