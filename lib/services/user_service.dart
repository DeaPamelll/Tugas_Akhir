import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserService {
  late Box<User> _userBox;

  Future<void> openBox() async {
    // Membuka box 'users'
    _userBox = await Hive.openBox<User>('users');
  }

  // Menyimpan user ke Hive
  Future<void> saveUser(User user) async {
    await openBox();
    // Kita gunakan email sebagai key unik
    await _userBox.put(user.email, user);
  }

  // Mendapatkan user berdasarkan email
  Future<User?> getUserByEmail(String email) async {
    await openBox();
    return _userBox.get(email);
  }
}