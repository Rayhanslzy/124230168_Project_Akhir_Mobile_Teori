// ---------------------------------------------------
// lib/features/search/bloc/search_state.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {} // State awal
class SearchLoading extends SearchState {} // State loading

class SearchLoaded extends SearchState {
  // State sukses
  final List<AnimeModel> results;
  const SearchLoaded({required this.results});
  @override
  List<Object> get props => [results];
}

class SearchError extends SearchState {
  // State error
  final String message;
  const SearchError({required this.message});
  @override
  List<Object> get props => [message];
}