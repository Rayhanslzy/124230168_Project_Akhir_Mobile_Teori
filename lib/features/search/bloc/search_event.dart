// ---------------------------------------------------
// lib/features/search/bloc/search_event.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

// Event yang dikirim saat teks di search bar berubah
class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged({required this.query});
  @override
  List<Object> get props => [query];
}