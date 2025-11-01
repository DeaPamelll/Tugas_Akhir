import 'package:hive/hive.dart';

part 'user_model.g.dart'; // File ini akan digenerate

@HiveType(typeId: 0) // typeId harus unik
class User extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password; // Ini akan berisi password yang SUDAH di-hash

  @HiveField(3)
  DateTime createdAt;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
  });
}