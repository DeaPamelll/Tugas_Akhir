import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  Box<User> get _userBox => Hive.box<User>('users');
  Box get _sessionBox => Hive.box('session');

  Future<void> saveUser(User user) async {
    await _userBox.put(user.email, user);
  }

  Future<User?> getUserByEmail(String email) async {
    return _userBox.get(email);
  }

  Future<void> deleteUser(String email) async {
    await _userBox.delete(email);
  }

  Future<String?> getLoggedInEmail() async {
    return _sessionBox.get('user_email_v1');
  }
}
