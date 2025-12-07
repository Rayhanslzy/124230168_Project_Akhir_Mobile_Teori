// ---------------------------------------------------
// lib/logic/anime_detail_bloc.dart
// ---------------------------------------------------

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/anime_model.dart';
import '../models/my_anime_entry_model.dart';
import '../repositories/anime_repository.dart';
import '../repositories/my_list_repository.dart';

// --- EVENTS ---
abstract class AnimeDetailEvent extends Equatable {
  const AnimeDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadAnimeDetail extends AnimeDetailEvent {
  final int animeId;
  const LoadAnimeDetail({required this.animeId});
  @override
  List<Object> get props => [animeId];
}

class SaveAnimeEntry extends AnimeDetailEvent {
  final int animeId;
  final String title;
  final String coverImageUrl;
  final String status;
  final int progress;
  final int score;
  final DateTime? startDate;
  final DateTime? finishDate;
  final int totalRewatches;
  final String notes;

  const SaveAnimeEntry({
    required this.animeId,
    required this.title,
    required this.coverImageUrl,
    required this.status,
    required this.progress,
    required this.score,
    this.startDate,
    this.finishDate,
    this.totalRewatches = 0,
    this.notes = '',
  });

  @override
  List<Object?> get props => [animeId, title, coverImageUrl, status, progress, score, startDate, finishDate, totalRewatches, notes];
}

class RemoveFromMyList extends AnimeDetailEvent {
  final int animeId;
  const RemoveFromMyList({required this.animeId});
  @override
  List<Object> get props => [animeId];
}

class UpdateEntryProgress extends AnimeDetailEvent {
  final int progress;
  final int maxEpisodes;
  const UpdateEntryProgress({required this.progress, required this.maxEpisodes});
  @override
  List<Object> get props => [progress, maxEpisodes];
}

// --- STATES ---
abstract class AnimeDetailState extends Equatable {
  const AnimeDetailState();
  @override
  List<Object?> get props => [];
}

class AnimeDetailLoading extends AnimeDetailState {}

class AnimeDetailError extends AnimeDetailState {
  final String message;
  const AnimeDetailError({required this.message});
  @override
  List<Object> get props => [message];
}

class AnimeDetailLoaded extends AnimeDetailState {
  final AnimeModel anime;
  final bool isInMyList;
  final MyAnimeEntryModel? entry;

  const AnimeDetailLoaded({
    required this.anime,
    required this.isInMyList,
    this.entry,
  });

  @override
  List<Object?> get props => [anime, isInMyList, entry];

  AnimeDetailLoaded copyWith({
    AnimeModel? anime,
    bool? isInMyList,
    MyAnimeEntryModel? entry,
  }) {
    return AnimeDetailLoaded(
      anime: anime ?? this.anime,
      isInMyList: isInMyList ?? this.isInMyList,
      entry: entry,
    );
  }
}

// --- BLOC ---
class AnimeDetailBloc extends Bloc<AnimeDetailEvent, AnimeDetailState> {
  final AnimeRepository animeRepository;
  final MyListRepository myListRepository;
  final String userId; // DATA BARU: Wajib tau siapa yang login

  AnimeDetailBloc({
    required this.animeRepository,
    required this.myListRepository,
    required this.userId, 
  }) : super(AnimeDetailLoading()) {
    
    on<LoadAnimeDetail>((event, emit) async {
      emit(AnimeDetailLoading());
      try {
        final anime = await animeRepository.getAnimeDetail(event.animeId);
        // Cek list pake userId
        final bool isInList = myListRepository.isInList(userId, event.animeId);
        final MyAnimeEntryModel? entry = isInList ? myListRepository.getEntry(userId, event.animeId) : null;

        emit(AnimeDetailLoaded(
          anime: anime,
          isInMyList: isInList,
          entry: entry,
        ));
      } catch (e) {
        emit(AnimeDetailError(message: e.toString().replaceFirst("Exception: ", "")));
      }
    });

    on<SaveAnimeEntry>((event, emit) async {
      if (state is AnimeDetailLoaded) {
        final currentState = state as AnimeDetailLoaded;

        final newEntry = MyAnimeEntryModel(
          animeId: event.animeId,
          title: event.title,
          coverImageUrl: event.coverImageUrl,
          status: event.status,
          episodesWatched: event.progress,
          userScore: event.score,
          startDate: event.startDate,
          finishDate: event.finishDate,
          totalRewatches: event.totalRewatches,
          notes: event.notes,
          userId: userId, // Masukkan userId ke data
        );

        await myListRepository.addOrUpdateAnime(newEntry);
        
        emit(currentState.copyWith(
          isInMyList: true,
          entry: newEntry,
        ));
      }
    });

    on<RemoveFromMyList>((event, emit) async {
      if (state is AnimeDetailLoaded) {
        // Hapus spesifik punya user ini
        await myListRepository.deleteAnime(userId, event.animeId);
        emit((state as AnimeDetailLoaded).copyWith(isInMyList: false, entry: null));
      }
    });

    on<UpdateEntryProgress>((event, emit) async {
      if (state is AnimeDetailLoaded) {
        final currentState = state as AnimeDetailLoaded;
        if (currentState.entry == null) return;

        final oldEntry = currentState.entry!;
        String newStatus = oldEntry.status;

        if (event.maxEpisodes > 0 && event.progress >= event.maxEpisodes) {
          newStatus = 'Completed';
        } else if (event.progress > 0 && newStatus == 'Planning') {
          newStatus = 'Watching';
        }

        final newEntry = MyAnimeEntryModel(
          animeId: oldEntry.animeId,
          title: oldEntry.title,
          coverImageUrl: oldEntry.coverImageUrl,
          status: newStatus,
          userScore: oldEntry.userScore,
          episodesWatched: event.progress,
          startDate: oldEntry.startDate,
          finishDate: oldEntry.finishDate,
          totalRewatches: oldEntry.totalRewatches,
          notes: oldEntry.notes,
          userId: userId, // Jangan lupa userId
        );

        await myListRepository.addOrUpdateAnime(newEntry);

        emit(currentState.copyWith(entry: newEntry));
      }
    });
  }
}