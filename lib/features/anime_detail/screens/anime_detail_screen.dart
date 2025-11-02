// ---------------------------------------------------
// lib/features/anime_detail/screens/anime_detail_screen.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ta_teori/data/models/anime_model.dart';
import 'package:ta_teori/data/models/my_anime_entry_model.dart'; // Import model MyAnimeEntry
import 'package:ta_teori/data/repositories/anime_repository.dart';
import 'package:ta_teori/data/repositories/my_list_repository.dart';
import 'package:ta_teori/features/anime_detail/bloc/anime_detail_bloc.dart';

// Halaman Wrapper untuk menyediakan BLoC
class AnimeDetailScreen extends StatelessWidget {
  final int animeId; // 1. Halaman ini butuh ID anime

  const AnimeDetailScreen({super.key, required this.animeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnimeDetailBloc(
        // 2. Sediakan DUA repository
        animeRepository: RepositoryProvider.of<AnimeRepository>(context),
        myListRepository: RepositoryProvider.of<MyListRepository>(context),
      )
        // 3. Langsung kirim event untuk memuat data
        ..add(LoadAnimeDetail(animeId: animeId)),
      child: const AnimeDetailView(),
    );
  }
}

// UI Halaman Detail
class AnimeDetailView extends StatelessWidget {
  const AnimeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 4. Kita gunakan BlocBuilder untuk menampilkan UI
      body: BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
        builder: (context, state) {
          // --- State Loading ---
          if (state is AnimeDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- State Error ---
          if (state is AnimeDetailError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // --- State Sukses (Loaded) ---
          if (state is AnimeDetailLoaded) {
            final anime = state.anime; // Data dari API

            // CustomScrollView memungkinkan kita menggabungkan
            // AppBar yang bisa-collapse dengan konten List
            return CustomScrollView(
              slivers: [
                // --- AppBar yang bisa Collapse dengan Gambar ---
                SliverAppBar(
                  expandedHeight: 350.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      anime.title,
                      style: const TextStyle(shadows: [Shadow(blurRadius: 5)]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    background: Image.network(
                      anime.coverImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image));
                      },
                    ),
                  ),
                ),

                // --- Konten (Deskripsi, Genre, dll) ---
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // --- Tombol Aksi (TAMBAH KE LIST) ---
                      _buildActionButtons(context, state),

                      const SizedBox(height: 16),

                      // --- Info (Skor & Genre) ---
                      _buildInfoSection(anime),

                      const Divider(height: 32),

                      // --- Sinopsis ---
                      _buildDescriptionSection(anime),
                      
                      const SizedBox(height: 32), // Spasi di bawah
                    ],
                  ),
                ),
              ],
            );
          }

          return Container(); // Fallback
        },
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Widget untuk Tombol Aksi (PENTING)
  Widget _buildActionButtons(BuildContext context, AnimeDetailLoaded state) {
    final anime = state.anime;

    // Teks tombol berdasarkan status
    final String buttonText = state.isInMyList
        ? 'Status: ${state.entry!.status}' // Tampilkan status (misal: "Watching")
        : 'Tambah ke List Saya';
    // Ikon tombol berdasarkan status
    final IconData buttonIcon =
        state.isInMyList ? Icons.check_circle : Icons.add_circle_outline;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Tombol Tambah/Update
          ElevatedButton.icon(
            icon: Icon(buttonIcon),
            label: Text(buttonText),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: state.isInMyList ? Colors.green : Colors.blue,
            ),
            onPressed: () {
              // Menampilkan Modal untuk memilih status
              _showStatusModal(context, anime, state.entry);
            },
          ),

          // Tampilkan tombol Hapus HANYA jika sudah ada di list
          if (state.isInMyList) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Hapus dari List',
                  style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Kirim event Hapus ke BLoC
                context
                    .read<AnimeDetailBloc>()
                    .add(RemoveFromMyList(animeId: anime.id));
              },
            ),
          ]
        ],
      ),
    );
  }

  // Widget untuk Info (Skor & Genre)
  Widget _buildInfoSection(AnimeModel anime) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Skor ---
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 30),
              const SizedBox(width: 8),
              Text(
                anime.averageScore != null
                    ? '${(anime.averageScore! / 10.0).toStringAsFixed(1)} / 10'
                    : 'N/A',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Genre ---
          if (anime.genres != null && anime.genres!.isNotEmpty) ...[
            const Text('Genre:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Wrap akan otomatis memindahkan item ke baris baru jika tidak muat
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: anime.genres!
                  .map((genre) => Chip(
                        label: Text(genre),
                        backgroundColor: Colors.grey.shade800,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  // Widget untuk Sinopsis
  Widget _buildDescriptionSection(AnimeModel anime) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sinopsis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            // Hapus tag <br> jika ada (AniList API)
            anime.description?.replaceAll(RegExp(r'<br\s*\/?>'), '\n\n') ??
                'Tidak ada sinopsis.',
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  // --- MODAL UNTUK PILIH STATUS (PENTING) ---
  void _showStatusModal(
      BuildContext context, AnimeModel anime, MyAnimeEntryModel? entry) {
    // Ambil BLoC dari context
    final bloc = context.read<AnimeDetailBloc>();

    // Daftar Status
    const statuses = ['Watching', 'Completed', 'Paused', 'Dropped', 'Planning'];

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Status List',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              // Buat list tombol untuk setiap status
              ...statuses.map((status) {
                return ListTile(
                  title: Text(status),
                  // Tandai status yang sedang aktif
                  trailing: (entry?.status == status)
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    // Kirim Event 'AddOrUpdateMyList' ke BLoC
                    bloc.add(AddOrUpdateMyList(
                      animeId: anime.id,
                      title: anime.title,
                      coverImageUrl: anime.coverImageUrl,
                      status: status,
                    ));
                    Navigator.of(ctx).pop(); // Tutup modal
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}