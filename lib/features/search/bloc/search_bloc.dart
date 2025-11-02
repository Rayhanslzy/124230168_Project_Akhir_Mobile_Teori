// ---------------------------------------------------
// lib/features/search/bloc/search_bloc.dart (REVISI FINAL - Perbaikan Import)
// ---------------------------------------------------

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// PERBAIKAN: Mengganti 'package.' menjadi 'package:'
import 'package:stream_transform/stream_transform.dart';

import 'package:ta_teori/data/models/anime_model.dart';
import 'package:ta_teori/data/repositories/anime_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

// 2. BUAT FUNGSI DEBOUNCER
// Durasi 500ms adalah standar yang baik
EventTransformer<E> _debounce<E>(Duration duration) {
  return (events, mapper) {
    return events.debounce(duration).switchMap(mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final AnimeRepository animeRepository;

  SearchBloc({required this.animeRepository}) : super(SearchInitial()) {
    on<SearchQueryChanged>(
      (event, emit) async {
        // Jika query kosong, jangan panggil API
        if (event.query.isEmpty) {
          emit(SearchInitial());
          return;
        }

        emit(SearchLoading());
        try {
          final results = await animeRepository.searchAnime(event.query);
          emit(SearchLoaded(results: results));
        } catch (e) {
          emit(SearchError(
              message: e.toString().replaceFirst("Exception: ", "")));
        }
      },
      // 3. TERAPKAN DEBOUNCER DI SINI
      transformer: _debounce(const Duration(milliseconds: 500)),
    );
  }
}
