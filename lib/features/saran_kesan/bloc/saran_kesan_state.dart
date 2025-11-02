part of 'saran_kesan_bloc.dart';

abstract class SaranKesanState extends Equatable {
  const SaranKesanState();
  @override
  List<Object?> get props => [];
}

class SaranKesanInitial extends SaranKesanState {}
class SaranKesanLoading extends SaranKesanState {}

// State saat data berhasil disimpan
class SaranKesanSaveSuccess extends SaranKesanState {}

// State saat data berhasil dimuat
class SaranKesanLoaded extends SaranKesanState {
  // Data bisa jadi null jika belum pernah disimpan
  final SaranKesan? entry;
  const SaranKesanLoaded({this.entry});
  @override
  List<Object?> get props => [entry];
}

// State jika terjadi error
class SaranKesanError extends SaranKesanState {
  final String message;
  const SaranKesanError({required this.message});
  @override
  List<Object> get props => [message];
}