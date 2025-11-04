import 'package:bcrypt/bcrypt.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';
import 'user_service.dart';

class AuthService {
  final UserService _userService = UserService();
  final Box _session = Hive.box('session'); 

  
  static const _kLoggedIn = 'is_logged_in_v1';
  static const _kUserId   = 'user_id_v1';
  static const _kEmail    = 'user_email_v1';
  static const _kName     = 'user_name_v1';

  Future<String> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final existing = await _userService.getUserByEmail(email);
      if (existing != null) return "Error: Email sudah terdaftar.";

      final hashed = BCrypt.hashpw(password, BCrypt.gensalt());
      final newUser = User(
        username: username,
        email: email,
        password: hashed,
        createdAt: DateTime.now(),
      );

      await _userService.saveUser(newUser);


      return "Success: Registrasi berhasil.";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _userService.getUserByEmail(email);
      if (user == null) return "Error: Email tidak ditemukan.";

      final ok = BCrypt.checkpw(password, user.password);
      if (!ok) return "Error: Password salah.";

      await _persistSession(user);
      return "Success: Login berhasil. Halo, ${user.username}!";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<void> logout() async {
    await _session.delete(_kLoggedIn);
    await _session.delete(_kUserId);
    await _session.delete(_kEmail);
    await _session.delete(_kName);
  }

  Future<void> _persistSession(User user) async {
  
    final int derivedId = _stableUserId(user.email);

    await _session.put(_kLoggedIn, true);
    await _session.put(_kUserId, derivedId);
    await _session.put(_kEmail, user.email);
    await _session.put(_kName, user.username ?? '');
  }

  int _stableUserId(String email) => email.trim().toLowerCase().hashCode;

  Future<bool> isLoggedIn() async =>
      _session.get(_kLoggedIn, defaultValue: false) as bool;

  Future<int?> currentUserId() async =>
      _session.get(_kUserId) as int?;

  Future<String?> currentEmail() async =>
      _session.get(_kEmail) as String?;

  Future<String?> currentName() async =>
      _session.get(_kName) as String?;
}
