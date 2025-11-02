// ---------------------------------------------------
// lib/features/shell/screen/main_shell.dart (Update)
// ---------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// BARU: Import AuthBloc dan LoginPage
import 'package:ta_teori/features/auth/bloc/auth_bloc.dart';
import 'package:ta_teori/features/auth/screens/login_screen.dart'; 
// Import halaman-halaman lain
import 'package:ta_teori/features/home/screens/home_screen.dart';
import 'package:ta_teori/features/my_list/screens/my_list_screen.dart';
import 'package:ta_teori/features/profile/screens/profile_screen.dart';
import 'package:ta_teori/features/search/screens/search_screen.dart';
import 'package:ta_teori/features/shell/cubit/shell_cubit.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShellCubit(),
      // BARU: Bungkus MainShellView dengan BlocListener
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Jika state berubah jadi Unauthenticated (karena logout)
          if (state is AuthUnauthenticated) {
            // Pindah paksa kembali ke LoginPage
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false, // Hapus semua halaman
            );
          }
        },
        child: const MainShellView(),
      ),
    );
  }
}

// Class MainShellView (UI) tetap sama
class MainShellView extends StatelessWidget {
  const MainShellView({super.key});

  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(),
    MyListScreen(),
    ProfileScreen(), // Pastikan ProfileScreen ada di sini
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<ShellCubit>().state;

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex, 
        onTap: (index) {
          context.read<ShellCubit>().changePage(index);
        },
        type: BottomNavigationBarType.fixed, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'My List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}