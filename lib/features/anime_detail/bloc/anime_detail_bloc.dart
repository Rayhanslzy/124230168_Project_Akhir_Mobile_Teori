// ---------------------------------------------------
// lib/features/anime_detail/bloc/anime_detail_bloc.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ta_teori/data/models/anime_model.dart';
import 'package:ta_teori/data/models/my_anime_entry_model.dart';
import 'package:ta_teori/data/repositories/anime_repository.dart';
import 'package:ta_teori/data/repositories/my_list_repository.dart';

part 'anime_detail_event.dart';
part 'anime_detail_state.dart';

class AnimeDetailBloc extends Bloc<AnimeDetailEvent, AnimeDetailState> {
  final AnimeRepository animeRepository;
  final MyListRepository myListRepository;

  AnimeDetailBloc({
    required this.animeRepository,
    required this.myListRepository,
  }) : super(AnimeDetailLoading()) {
    
    // --- Handler untuk Load Data ---
    on<LoadAnimeDetail>((event, emit) async {
      emit(AnimeDetailLoading());
      try {
        // 1. Ambil data detail dari API
        final anime = await animeRepository.getAnimeDetail(event.animeId);

        // 2. Cek status di Hive
        final bool isInList = myListRepository.isInList(event.animeId);
        MyAnimeEntryModel? entry;
        if (isInList) {
          entry = myListRepository.getEntry(event.animeId);
        }

        // 3. Emit state sukses
        emit(AnimeDetailLoaded(
          anime: anime,
          isInMyList: isInList,
          entry: entry,
        ));
      } catch (e) {
        emit(AnimeDetailError(message: e.toString().replaceFirst("Exception: ", "")));
      }
    });

    // --- Handler untuk Tambah/Update List ---
    on<AddOrUpdateMyList>((event, emit) async {
      // Hanya bekerja jika state-nya 'Loaded'
      if (state is AnimeDetailLoaded) {
        final currentState = state as AnimeDetailLoaded;

        // 1. Buat entry baru
        final newEntry = MyAnimeEntryModel(
          animeId: event.animeId,
          title: event.title,
          coverImageUrl: event.coverImageUrl,
          status: event.status,
          // (Nanti kita bisa tambahkan skor pribadi)
        );

        // 2. Simpan ke Hive
        await myListRepository.addOrUpdateAnime(newEntry);

        // 3. Emit state baru (sama, tapi update status list)
        emit(currentState.copyWith(
          isInMyList: true,
          entry: newEntry,
        ));
      }
    });

    // --- Handler untuk Hapus List ---
    on<RemoveFromMyList>((event, emit) async {
      if (state is AnimeDetailLoaded) {
        final currentState = state as AnimeDetailLoaded;

        // 1. Hapus dari Hive
        await myListRepository.deleteAnime(event.animeId);

        // 2. Emit state baru
        emit(currentState.copyWith(
          isInMyList: false,
          entry: null,
        ));
      }
    });
  }
}