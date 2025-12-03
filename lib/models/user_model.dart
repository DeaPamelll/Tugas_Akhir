import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  String? role;

  @HiveField(6)
  String? photoPath;

  @HiveField(7)
  List<String>? hobbies;

  @HiveField(8)
  String? instagram;

  @HiveField(9)
  String? nim;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
    this.role = 'user',
    this.photoPath,
    this.hobbies,
    this.instagram,
    this.nim,
  });

  User copyWith({
    String? username,
    String? email,
    String? password,
    String? photoPath,
    List<String>? hobbies,
    String? instagram,
    String? nim,
  }) {
    return User(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt,
      role: role,
      photoPath: photoPath ?? this.photoPath,
      hobbies: hobbies ?? this.hobbies,
      instagram: instagram ?? this.instagram,
      nim: nim ?? this.nim,
    );
  }
}
