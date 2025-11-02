// ---------------------------------------------------
// lib/features/lbs_demo/bloc/lbs_bloc.dart (SUDAH BENAR - Tidak ada revisi)
// ---------------------------------------------------

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart'; // Import Position (Ini akan terpakai)
import 'package:ta_teori/data/repositories/location_repository.dart';

part 'lbs_event.dart';
part 'lbs_state.dart';

class LbsBloc extends Bloc<LbsEvent, LbsState> {
  final LocationRepository locationRepository;

  LbsBloc({required this.locationRepository}) : super(LbsInitial()) {
    // Handler untuk event 'FetchLocation'
    on<FetchLocation>((event, emit) async {
      emit(LbsLoading());
      try {
        // Panggil repository
        final position = await locationRepository.getCurrentPosition();
        // Jika sukses, kirim data lokasi
        emit(LbsLoaded(position: position));
      } catch (e) {
        // Jika error (izin ditolak, dll), kirim pesan error
        emit(LbsError(message: e.toString().replaceFirst("Exception: ", "")));
      }
    });
  }
}