// ---------------------------------------------------
// lib/data/repositories/auth_repository.dart
// ---------------------------------------------------

import 'package:hive_flutter/hive_flutter.dart';
import 'package:bcrypt/bcrypt.dart'; // 1. Import bcrypt untuk enkripsi
import 'package:ta_teori/data/models/user_model.dart'; // 2. Import model User kita

class AuthRepository {
  
  // 3. Ambil 'userBox' yang sudah kita buka di main.dart
  final Box<User> _userBox = Hive.box<User>('userBox');

  // --- Fungsi Registrasi ---
  Future<void> register(String username, String password) async {
    // 4. Cek apakah username sudah ada
    if (_userBox.containsKey(username)) {
      throw Exception('Username sudah terdaftar');
    }

    // 5. Enkripsi password (Ini adalah syarat tugas Anda)
    // BCrypt.hashpw() adalah fungsi enkripsi yang aman
    final String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    // 6. Buat objek User baru
    final newUser = User(
      username: username,
      encryptedPassword: hashedPassword, // Simpan password yang sudah di-hash
    );

    // 7. Simpan user baru ke Hive
    // Kita gunakan 'username' sebagai 'key' unik
    await _userBox.put(username, newUser);
  }

  // --- Fungsi Login ---
  Future<User> login(String username, String password) async {
    // 8. Ambil data user dari Hive berdasarkan 'key' (username)
    final user = _userBox.get(username);

    // 9. Cek jika user tidak ada
    if (user == null) {
      throw Exception('Username tidak ditemukan');
    }

    // 10. Verifikasi password (Ini bagian penting)
    // BCrypt.checkpw() membandingkan password mentah dengan hash di DB
    final bool isPasswordMatch = BCrypt.checkpw(password, user.encryptedPassword);

    if (!isPasswordMatch) {
      throw Exception('Password salah');
    }

    // 11. Jika berhasil, kembalikan data user
    // Di sini kita bisa set 'session', tapi untuk sekarang kita kembalikan User
    return user;
  }

  // --- Fungsi Logout (Sederhana) ---
  Future<void> logout() async {
    // Untuk 'session' sederhana, kita bisa simpan status login di box lain
    // Tapi untuk sekarang, logout tidak melakukan apa-apa di sisi data
    // Kita akan tangani ini di BLoC nanti
  }
}