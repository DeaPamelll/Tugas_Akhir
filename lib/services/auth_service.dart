import 'package:bcrypt/bcrypt.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';
import 'user_service.dart';

class AdminUser {
  final String email = "admin@gmail.com"; 
  final String password = "admin123"; 
  final String username = "Administrator";
  final int id = -1;
  final String role = 'admin';
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final UserService _userService = UserService();
  
  Box get _session => Hive.box('session');

  static final _admin = AdminUser();
  static const _kRole     = 'user_role_v1'; 
  static const _kLoggedIn = 'is_logged_in_v1';
  static const _kUserId = 'user_id_v1';
  static const _kEmail  = 'user_email_v1';
  static const _kName = 'user_name_v1';

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
        role: 'user', 
      );

      await _userService.saveUser(newUser);


      return "Success: Registrasi berhasil.";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<bool> loginAdmin({
    required String email,
    required String password,
  }) async {
    if (email == _admin.email && password == _admin.password) {
      
      final adminSession = User(
        id: _admin.id,
        username: _admin.username,
        email: _admin.email,
        password: '',
        createdAt: DateTime.now(),
        role: _admin.role,
      );

      await _persistSession(adminSession); 
      return true;
    }
    return false;
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
      return "SuccessUser: Login berhasil. Halo, ${user.username}!";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<void> logout() async {
    await _session.delete(_kLoggedIn);
    await _session.delete(_kUserId);
    await _session.delete(_kEmail);
    await _session.delete(_kName);
    await _session.delete(_kRole); 
  }

  Future<void> _persistSession(User user) async {
    final int derivedId = user.id ?? _stableUserId(user.email); 
    final String userRole = user.role ?? 'user'; 

    await _session.put(_kLoggedIn, true);
    await _session.put(_kUserId, derivedId);
    await _session.put(_kEmail, user.email);
    await _session.put(_kName, user.username ?? '');
    await _session.put(_kRole, userRole); 
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
      
  Future<String?> currentUserRole() async => 
      _session.get(_kRole) as String?;

  Future<bool> isAdmin() async =>
      _session.get(_kRole) == 'admin';
      
  Future<User?> getCurrentUser() async {
    final id = await currentUserId();
    final email = await currentEmail();
    final role = await currentUserRole();

    if (id == null || email == null) return null;


    if (role == 'admin' && id == _admin.id) {
      return User(
        id: _admin.id,
        username: _admin.username,
        email: _admin.email,
        password: '',
        createdAt: DateTime.now(),
        role: 'admin',
      );
    }

    final user = await _userService.getUserByEmail(email);
    return user;
  }
}