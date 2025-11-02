// ---------------------------------------------------
// lib/features/anime_detail/bloc/anime_detail_state.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

part of 'anime_detail_bloc.dart';

abstract class AnimeDetailState extends Equatable {
  const AnimeDetailState();
  @override
  List<Object?> get props => [];
}

// State awal saat loading data dari API
class AnimeDetailLoading extends AnimeDetailState {}

// State saat gagal load dari API
class AnimeDetailError extends AnimeDetailState {
  final String message;
  const AnimeDetailError({required this.message});
  @override
  List<Object> get props => [message];
}

// State saat semua data berhasil dimuat
class AnimeDetailLoaded extends AnimeDetailState {
  final AnimeModel anime; // Data dari API
  final bool isInMyList; // Status dari Hive
  final MyAnimeEntryModel? entry; // Data dari Hive (jika ada)

  const AnimeDetailLoaded({
    required this.anime,
    required this.isInMyList,
    this.entry,
  });

  @override
  List<Object?> get props => [anime, isInMyList, entry];

  // Helper method untuk copy state
  AnimeDetailLoaded copyWith({
    AnimeModel? anime,
    bool? isInMyList,
    MyAnimeEntryModel? entry,
  }) {
    return AnimeDetailLoaded(
      anime: anime ?? this.anime,
      isInMyList: isInMyList ?? this.isInMyList,
      // Penting: kita harus bisa set 'entry' menjadi null
      // jika kita menghapus dari list
      entry: entry,
    );
  }
}