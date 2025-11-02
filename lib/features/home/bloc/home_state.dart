// ---------------------------------------------------
// lib/features/home/bloc/home_state.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

// State Awal / Kosong
class HomeInitial extends HomeState {}

// State saat sedang loading data
class HomeLoading extends HomeState {}

// State saat data berhasil dimuat
class HomeLoaded extends HomeState {
  // Kita simpan data anime di dalam state ini
  final List<AnimeModel> popularAnime;

  const HomeLoaded({required this.popularAnime});

  @override
  List<Object> get props => [popularAnime];
}

// State saat terjadi error
class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}