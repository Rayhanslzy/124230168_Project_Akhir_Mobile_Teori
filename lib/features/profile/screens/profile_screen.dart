// ---------------------------------------------------
// lib/features/profile/screens/profile_screen.dart (REVISI FINAL - Tambah Menu Notifikasi)
// ---------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ta_teori/features/auth/bloc/auth_bloc.dart';
import 'package:ta_teori/features/utils_menu/screens/converter_screen.dart';
import 'package:ta_teori/features/saran_kesan/screens/saran_kesan_screen.dart';
import 'package:ta_teori/features/lbs_demo/screens/lbs_demo_screen.dart';
// IMPORT BARU
import 'package:ta_teori/features/utils_menu/screens/notification_demo_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Ambil username jika user sudah terautentikasi
          String username = 'Guest';
          if (state is AuthAuthenticated) {
            username = state.user.username;
          }

          return ListView(
            children: [
              // --- Bagian Info Profil (Syarat Tugas) ---
              UserAccountsDrawerHeader(
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                accountName: Text(
                  username,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                accountEmail: const Text('Pengguna Aplikasi Anime'),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                ),
              ),

              // --- Menu Saran dan Kesan (Syarat Tugas) ---
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: const Text('Saran dan Kesan'),
                subtitle: const Text('Berikan masukan Anda'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SaranKesanScreen(),
                    ),
                  );
                },
              ),

              const Divider(),

              // --- Menu Konverter (Syarat Tugas) ---
              ListTile(
                leading: const Icon(Icons.calculate_outlined),
                title: const Text('Konverter'),
                subtitle: const Text('Konversi Waktu & Mata Uang'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ConverterScreen(),
                    ),
                  );
                },
              ),

              const Divider(),

              // --- Menu LBS Demo ---
              ListTile(
                leading: const Icon(Icons.gps_fixed_outlined),
                title: const Text('Demo LBS (GPS)'),
                subtitle: const Text('Menampilkan lokasi Anda saat ini'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LbsDemoScreen(),
                    ),
                  );
                },
              ),

              const Divider(),

              // --- PENAMBAHAN BARU: Menu Demo Notifikasi ---
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('Demo Notifikasi'),
                subtitle: const Text('Tes notifikasi lokal terjadwal'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationDemoScreen(),
                    ),
                  );
                },
              ),

              const Divider(),

              // --- Tombol Logout (Syarat Tugas) ---
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title:
                    const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Anda yakin ingin logout?'),
                      actions: [
                        TextButton(
                          child: const Text('Batal'),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                        TextButton(
                          child: const Text('Logout',
                              style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            // Kirim event Logout ke AuthBloc
                            context.read<AuthBloc>().add(LogoutButtonPressed());
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}