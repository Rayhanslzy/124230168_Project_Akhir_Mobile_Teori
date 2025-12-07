// ---------------------------------------------------
// lib/logic/location_cubit.dart
// ---------------------------------------------------

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/location_service.dart';

// --- STATES ---
abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}
class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final String city;
  final String zone;    // WIB, WITA, WIT
  final int offset;     // 7, 8, 9

  const LocationLoaded({
    required this.city,
    required this.zone,
    required this.offset,
  });

  @override
  List<Object> get props => [city, zone, offset];
}

class LocationError extends LocationState {
  final String message;
  const LocationError(this.message);
  @override
  List<Object> get props => [message];
}

// --- CUBIT ---
class LocationCubit extends Cubit<LocationState> {
  final LocationService locationService;

  LocationCubit({required this.locationService}) : super(LocationInitial());

  Future<void> detectLocation() async {
    emit(LocationLoading());
    try {
      final result = await locationService.getCurrentLocation();
      emit(LocationLoaded(
        city: result['city'],
        zone: result['zone'],
        offset: result['offset'],
      ));
    } catch (e) {
      emit(LocationError(e.toString().replaceFirst("Exception: ", "")));
    }
  }
}