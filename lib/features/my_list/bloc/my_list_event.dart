// ---------------------------------------------------
// lib/features/my_list/bloc/my_list_event.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

part of 'my_list_bloc.dart';

abstract class MyListEvent extends Equatable {
  const MyListEvent();
  @override
  List<Object> get props => [];
}

// Event untuk mengambil semua data dari Hive
class LoadMyList extends MyListEvent {}

// Event untuk menghapus item dari Hive
class RemoveFromMyList extends MyListEvent {
  final int animeId;
  const RemoveFromMyList({required this.animeId});
  @override
  List<Object> get props => [animeId];
}