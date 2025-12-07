// ---------------------------------------------------------
// lib/logic/my_list_bloc.dart
// ---------------------------------------------------------

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/my_anime_entry_model.dart';
import '../repositories/my_list_repository.dart';

// --- EVENTS ---
abstract class MyListEvent extends Equatable {
  const MyListEvent();
  @override
  List<Object> get props => [];
}

class LoadMyList extends MyListEvent {
  final String userId;
  const LoadMyList({required this.userId});
  @override
  List<Object> get props => [userId];
}

// EVENT BARU: Buat hapus memori saat logout
class ClearMyList extends MyListEvent {} 

class RemoveFromMyList extends MyListEvent {
  final String userId;
  final int animeId;
  const RemoveFromMyList({required this.userId, required this.animeId});
  @override
  List<Object> get props => [userId, animeId];
}

class AddOrUpdateEntry extends MyListEvent {
  final MyAnimeEntryModel entry;
  const AddOrUpdateEntry({required this.entry});
  @override
  List<Object> get props => [entry];
}

class UpdateEpisodeProgress extends MyListEvent {
  final String userId;
  final int animeId;
  final int newProgress;
  final int maxEpisodes; 

  const UpdateEpisodeProgress({
    required this.userId,
    required this.animeId, 
    required this.newProgress,
    required this.maxEpisodes,
  });

  @override
  List<Object> get props => [userId, animeId, newProgress, maxEpisodes];
}

// --- STATES ---
abstract class MyListState extends Equatable {
  const MyListState();
  @override
  List<Object> get props => [];
}

class MyListLoading extends MyListState {}

class MyListLoaded extends MyListState {
  final List<MyAnimeEntryModel> myList;
  const MyListLoaded({required this.myList});
  @override
  List<Object> get props => [myList];
}

// --- BLOC ---
class MyListBloc extends Bloc<MyListEvent, MyListState> {
  final MyListRepository myListRepository;

  MyListBloc({required this.myListRepository}) : super(MyListLoading()) {
    
    on<LoadMyList>((event, emit) {
      try {
        final list = myListRepository.getMyList(event.userId);
        emit(MyListLoaded(myList: list));
      } catch (e) {
        emit(const MyListLoaded(myList: []));
      }
    });

    // HANDLER BARU: Reset state jadi kosong
    on<ClearMyList>((event, emit) {
      emit(const MyListLoaded(myList: [])); 
    });

    on<AddOrUpdateEntry>((event, emit) async {
      await myListRepository.addOrUpdateAnime(event.entry);
      add(LoadMyList(userId: event.entry.userId)); 
    });

    on<RemoveFromMyList>((event, emit) async {
      await myListRepository.deleteAnime(event.userId, event.animeId);
      add(LoadMyList(userId: event.userId));
    });

    on<UpdateEpisodeProgress>((event, emit) async {
      final entry = myListRepository.getEntry(event.userId, event.animeId);
      
      if (entry != null) {
        entry.episodesWatched = event.newProgress;
        
        if (event.maxEpisodes > 0 && entry.episodesWatched >= event.maxEpisodes) {
          entry.status = 'Completed';
        } else if (entry.episodesWatched > 0 && entry.status == 'Planning') {
          entry.status = 'Watching';
        }

        await entry.save(); 
        add(LoadMyList(userId: event.userId));
      }
    });
  }
}