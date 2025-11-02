// ---------------------------------------------------
// lib/features/search/screens/search_screen.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import 'anime_card.dart' yang tidak terpakai sudah dihapus
import 'package:ta_teori/features/anime_detail/screens/anime_detail_screen.dart';
import 'package:ta_teori/data/repositories/anime_repository.dart';
import 'package:ta_teori/features/search/bloc/search_bloc.dart';

// Halaman Wrapper untuk menyediakan BLoC
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        // Ambil repository yang sudah terdaftar
        animeRepository: RepositoryProvider.of<AnimeRepository>(context),
      ),
      child: const SearchView(),
    );
  }
}

// UI Halaman Pencarian
class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Anime'),
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: true, // Langsung fokus saat halaman dibuka
              decoration: InputDecoration(
                hintText: 'Ketik judul anime...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (query) {
                // 3. Kirim event ke BLoC setiap kali teks berubah
                context.read<SearchBloc>().add(SearchQueryChanged(query: query));
              },
            ),
          ),

          // --- Hasil Pencarian ---
          Expanded(
            // 4. Gunakan BlocBuilder untuk menampilkan hasil
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                // --- State Awal ---
                if (state is SearchInitial) {
                  return const Center(
                    child: Text('Ketik di atas untuk mulai mencari...'),
                  );
                }

                // --- State Loading ---
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // --- State Sukses (Loaded) ---
                if (state is SearchLoaded) {
                  // Jika hasil kosong
                  if (state.results.isEmpty) {
                    return const Center(child: Text('Anime tidak ditemukan.'));
                  }

                  // Tampilkan hasil dalam ListView
                  return ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final anime = state.results[index];
                      return ListTile(
                        leading: Image.network(
                          anime.coverImageUrl,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(anime.title),
                        subtitle: Text(
                            'Skor: ${anime.averageScore != null ? (anime.averageScore! / 10.0).toStringAsFixed(1) : 'N/A'}'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  AnimeDetailScreen(animeId: anime.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                // --- State Error ---
                if (state is SearchError) {
                  return Center(
                    child: Text('Error: ${state.message}',
                        style: const TextStyle(color: Colors.red)),
                  );
                }

                return Container(); // Fallback
              },
            ),
          ),
        ],
      ),
    );
  }
}