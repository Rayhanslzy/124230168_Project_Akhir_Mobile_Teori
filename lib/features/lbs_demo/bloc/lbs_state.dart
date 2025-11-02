// ---------------------------------------------------
// lib/features/lbs_demo/bloc/lbs_state.dart (REVISI - Hapus import)
// ---------------------------------------------------

part of 'lbs_bloc.dart';

// Kita butuh ini untuk menampung data 'Position'
// import 'package:geolocator/geolocator.dart'; // <-- BARIS INI DIHAPUS

abstract class LbsState extends Equatable {
  const LbsState();
  @override
  List<Object> get props => [];
}

/// State awal, belum ada aksi
class LbsInitial extends LbsState {}

/// State saat sedang mengambil data GPS
class LbsLoading extends LbsState {}

/// State saat lokasi berhasil didapat
class LbsLoaded extends LbsState {
  // Tipe 'Position' akan otomatis dikenali dari import di lbs_bloc.dart
  final Position position;
  const LbsLoaded({required this.position});
  @override
  List<Object> get props => [position];
}

/// State saat terjadi error (misal: izin ditolak)
class LbsError extends LbsState {
  final String message;
  const LbsError({required this.message});
  @override
  List<Object> get props => [message];
}