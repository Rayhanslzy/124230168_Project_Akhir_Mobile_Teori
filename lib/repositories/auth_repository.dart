// ------------------------------------------
// lib/repositories/auth_repository.dart
// ------------------------------------------

import 'package:hive/hive.dart';
import 'package:bcrypt/bcrypt.dart';
import '../models/user_model.dart';

class AuthRepository {
  final Box<User> _userBox = Hive.box<User>('userBox');
  // Box ini harus dibuka di main.dart dulu
  final Box _sessionBox = Hive.box('sessionBox'); 

  /// Mendaftarkan user baru
  Future<void> register(String username, String password) async {
    if (_userBox.containsKey(username)) {
      throw Exception('Username sudah terdaftar');
    }
    final String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    final newUser = User(
      username: username,
      encryptedPassword: hashedPassword,
      profileImagePath: null,
    );
    await _userBox.put(username, newUser);
  }

  /// Login dan simpan sesi jika berhasil
  Future<User> login(String username, String password) async {
    final user = _userBox.get(username);
    if (user == null) {
      throw Exception('Username tidak ditemukan');
    }
    
    final bool isPasswordMatch = BCrypt.checkpw(password, user.encryptedPassword);
    if (!isPasswordMatch) {
      throw Exception('Password salah');
    }

    // SIMPAN SESI: Simpan username pengguna yang sedang login
    await _sessionBox.put('current_user', user.username);

    return user;
  }

  /// Mengecek apakah ada sesi aktif dan mengembalikan User-nya
  Future<User?> getCurrentUser() async {
    final String? currentUsername = _sessionBox.get('current_user');
    
    if (currentUsername != null && _userBox.containsKey(currentUsername)) {
      return _userBox.get(currentUsername);
    }
    
    return null;
  }

  /// Update foto profil
  Future<User> updateProfilePicture(String username, String newImagePath) async {
    final user = _userBox.get(username);

    if (user == null) {
      throw Exception('User tidak ditemukan saat update foto');
    }

    user.profileImagePath = newImagePath;
    await user.save();

    return User(
      username: user.username,
      encryptedPassword: user.encryptedPassword,
      profileImagePath: user.profileImagePath,
    );
  }

  /// Logout dan hapus sesi
  Future<void> logout() async {
    await _sessionBox.delete('current_user');
  }
}