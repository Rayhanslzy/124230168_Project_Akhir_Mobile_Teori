// ---------------------------------------------------
// lib/features/home/screens/home_screen.dart (REVISI - Hapus unused import)
// ---------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ta_teori/data/models/anime_model.dart'; // <-- BARIS INI DIHAPUS
import 'package:ta_teori/data/repositories/anime_repository.dart';
import 'package:ta_teori/features/anime_detail/screens/anime_detail_screen.dart';
import 'package:ta_teori/features/home/bloc/home_bloc.dart';
import 'package:ta_teori/core/widgets/anime_card.dart'; // <-- Ini sudah benar

// Ini adalah "Halaman Wrapper" yang menyediakan BLoC
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        // 1. Ambil AnimeRepository yang sudah kita daftarkan di main.dart
        animeRepository: RepositoryProvider.of<AnimeRepository>(context),
      )
        // 2. Kirim event 'FetchHomeData' SEGERA setelah BLoC dibuat
        ..add(FetchHomeData()),
      child: const HomeView(), // Tampilkan UI-nya
    );
  }
}

// Ini adalah UI Halaman Home yang sebenarnya
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Populer Musim Ini'),
        actions: [
          // Tambahkan tombol refresh untuk testing
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Kirim event lagi untuk refresh data
              context.read<HomeBloc>().add(FetchHomeData());
            },
          ),
        ],
      ),
      // 3. Gunakan BlocBuilder untuk membangun UI berdasarkan state
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // --- State Loading ---
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // --- State Sukses (Loaded) ---
          if (state is HomeLoaded) {
            // Tampilkan data menggunakan GridView
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom
                childAspectRatio: 0.7, // Rasio aspek (tinggi > lebar)
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.popularAnime.length, // Jumlah item
              itemBuilder: (context, index) {
                final anime = state.popularAnime[index];
                // Tampilkan kartu anime
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke Halaman Detail
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AnimeDetailScreen(animeId: anime.id),
                      ),
                    );
                  },
                  child: AnimeCard(anime: anime),
                );
              },
            );
          }

          // --- State Error ---
          if (state is HomeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gagal memuat data:\n${state.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // State default jika terjadi sesuatu yang aneh
          return const Center(child: Text('Terjadi kesalahan.'));
        },
      ),
    );
  }
}