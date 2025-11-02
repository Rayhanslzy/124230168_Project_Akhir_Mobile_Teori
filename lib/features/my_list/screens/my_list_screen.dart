// ---------------------------------------------------
// lib/features/my_list/screens/my_list_screen.dart (REVISI - Hapus unused import)
// ---------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ta_teori/data/models/my_anime_entry_model.dart'; // <-- BARIS INI DIHAPUS
import 'package:ta_teori/data/repositories/my_list_repository.dart';
import 'package:ta_teori/features/my_list/bloc/my_list_bloc.dart';

// Halaman Wrapper untuk menyediakan BLoC
class MyListScreen extends StatelessWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyListBloc(
        myListRepository: RepositoryProvider.of<MyListRepository>(context),
      )
        ..add(LoadMyList()), // Langsung kirim event untuk load data
      child: const MyListView(),
    );
  }
}

// UI Halaman "My List"
class MyListView extends StatelessWidget {
  const MyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Anime List (Lokal)'),
      ),
      // Kita gunakan BlocBuilder untuk menampilkan data
      body: BlocBuilder<MyListBloc, MyListState>(
        builder: (context, state) {
          // --- State Loading ---
          if (state is MyListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- State Sukses (Loaded) ---
          if (state is MyListLoaded) {
            // Jika list kosong
            if (state.myList.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'List Anda kosong.\nTambahkan anime dari halaman detail.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // Tampilkan list menggunakan ListView
            return ListView.builder(
              itemCount: state.myList.length,
              itemBuilder: (context, index) {
                final entry = state.myList[index];

                return ListTile(
                  leading: Image.network(
                    entry.coverImageUrl,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                  title: Text(entry.title),
                  subtitle: Text(
                      'Status: ${entry.status} | Skor: ${entry.userScore ?? 'N/A'}'),
                  // Tombol Hapus
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Tampilkan dialog konfirmasi
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Hapus Konfirmasi'),
                          content: Text(
                              'Anda yakin ingin menghapus ${entry.title} dari list?'),
                          actions: [
                            TextButton(
                              child: const Text('Batal'),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                            TextButton(
                              child: const Text('Hapus',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                // Kirim event hapus ke BLoC
                                context
                                    .read<MyListBloc>()
                                    .add(RemoveFromMyList(animeId: entry.animeId));
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Terjadi kesalahan.'));
        },
      ),
    );
  }
}