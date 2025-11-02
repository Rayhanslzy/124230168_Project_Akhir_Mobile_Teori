// ---------------------------------------------------
// lib/features/home/bloc/home_bloc.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ta_teori/data/models/anime_model.dart'; // Import model kita
import 'package:ta_teori/data/repositories/anime_repository.dart'; // Import repository kita

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AnimeRepository animeRepository;

  HomeBloc({required this.animeRepository}) : super(HomeInitial()) {
    // Mendaftarkan handler untuk event 'FetchHomeData'
    on<FetchHomeData>((event, emit) async {
      // 1. Emit state Loading saat event diterima
      emit(HomeLoading());

      try {
        // 2. Panggil repository untuk mengambil data
        final List<AnimeModel> animeList =
            await animeRepository.getPopularAnime();

        // 3. Jika sukses, emit state Loaded sambil membawa data
        emit(HomeLoaded(popularAnime: animeList));
      } catch (e) {
        // 4. Jika gagal, emit state Error sambil membawa pesan
        emit(HomeError(message: e.toString().replaceFirst("Exception: ", "")));
      }
    });
  }
}