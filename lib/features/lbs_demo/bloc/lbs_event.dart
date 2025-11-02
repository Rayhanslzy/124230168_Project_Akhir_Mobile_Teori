// ---------------------------------------------------
// lib/features/lbs_demo/bloc/lbs_event.dart (File Baru)
// ---------------------------------------------------

part of 'lbs_bloc.dart';

abstract class LbsEvent extends Equatable {
  const LbsEvent();
  @override
  List<Object> get props => [];
}

/// Event untuk memicu pengambilan data lokasi
class FetchLocation extends LbsEvent {}