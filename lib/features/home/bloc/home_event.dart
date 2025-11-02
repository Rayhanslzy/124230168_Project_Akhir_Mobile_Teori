// ---------------------------------------------------
// lib/features/home/bloc/home_event.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

// Event ini akan kita panggil saat Halaman Home pertama kali dibuka
class FetchHomeData extends HomeEvent {}