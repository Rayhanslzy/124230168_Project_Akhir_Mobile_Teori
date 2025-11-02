// ---------------------------------------------------
// lib/features/auth/screens/login_screen.dart (REVISI - Hapus unused import)
// ---------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ta_teori/data/repositories/auth_repository.dart'; // <-- BARIS INI DIHAPUS
import 'package:ta_teori/features/auth/bloc/auth_bloc.dart';
import 'package:ta_teori/features/auth/screens/register_screen.dart';
import 'package:ta_teori/features/shell/screen/main_shell.dart';

// Ini adalah "Halaman Wrapper"
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Langsung return UI-nya. BLoC sudah ada dari main.dart
    return const LoginScreen();
  }
}

// Ini adalah UI Halaman Login yang sebenarnya
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk mengambil teks dari form
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthBloc, AuthState>(
        // BlocListener HANYA untuk aksi (navigasi, snackbar)
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Langsung navigasi, tidak perlu 'if' lagi di dalam sini
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainShell()),
              (route) => false, // Hapus semua route di belakangnya
            );
          } else if (state is AuthError) {
            // Jika Gagal, tampilkan pesan error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selamat Datang!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true, // Sembunyikan password
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Ini adalah tombol Login
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  // Jika state-nya loading, tampilkan loading indicator
                  if (state is AuthLoading) {
                    return const CircularProgressIndicator();
                  }

                  // Jika tidak loading, tampilkan tombol
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {
                      // Ambil teks
                      final username = _usernameController.text;
                      final password = _passwordController.text;

                      // Kirim Event 'LoginButtonPressed' ke BLoC
                      context.read<AuthBloc>().add(
                            LoginButtonPressed(
                              username: username,
                              password: password,
                            ),
                          );
                    },
                    child: const Text('Login'),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Tombol untuk ke halaman Register
              TextButton(
                onPressed: () {
                  // Pindah ke halaman Register
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text('Belum punya akun? Daftar di sini'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}