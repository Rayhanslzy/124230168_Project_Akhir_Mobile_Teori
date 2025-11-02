// ---------------------------------------------------
// lib/features/anime_detail/bloc/anime_detail_event.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

part of 'anime_detail_bloc.dart';

abstract class AnimeDetailEvent extends Equatable {
  const AnimeDetailEvent();
  @override
  List<Object> get props => [];
}

// Event untuk mengambil data detail & cek status list
class LoadAnimeDetail extends AnimeDetailEvent {
  final int animeId;
  const LoadAnimeDetail({required this.animeId});
  @override
  List<Object> get props => [animeId];
}

// Event saat tombol "Tambah/Update List" ditekan
class AddOrUpdateMyList extends AnimeDetailEvent {
  // Kita butuh semua data ini untuk disimpan ke Hive
  final int animeId;
  final String title;
  final String coverImageUrl;
  final String status; // Misal: "Watching", "Completed", dll.

  const AddOrUpdateMyList({
    required this.animeId,
    required this.title,
    required this.coverImageUrl,
    required this.status,
  });

  // Perlu tambahkan props agar Equatable bekerja
  @override
  List<Object> get props => [animeId, title, coverImageUrl, status];
}

// Event saat tombol "Hapus dari List" ditekan
class RemoveFromMyList extends AnimeDetailEvent {
  final int animeId;
  const RemoveFromMyList({required this.animeId});
  @override
  List<Object> get props => [animeId];
}