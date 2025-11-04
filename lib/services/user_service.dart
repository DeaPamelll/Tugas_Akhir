import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserService {
  late Box<User> _userBox;

  Future<void> openBox() async {
    _userBox = await Hive.openBox<User>('users');
  }

  Future<void> saveUser(User user) async {
    await openBox();
    await _userBox.put(user.email, user);
  }

  Future<User?> getUserByEmail(String email) async {
    await openBox();
    return _userBox.get(email);
  }
}