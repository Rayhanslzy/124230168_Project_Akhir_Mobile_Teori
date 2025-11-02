// ---------------------------------------------------
// lib/features/my_list/bloc/my_list_bloc.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ta_teori/data/models/my_anime_entry_model.dart';
import 'package:ta_teori/data/repositories/my_list_repository.dart';

part 'my_list_event.dart';
part 'my_list_state.dart';

class MyListBloc extends Bloc<MyListEvent, MyListState> {
  final MyListRepository myListRepository;

  MyListBloc({required this.myListRepository}) : super(MyListLoading()) {
    // Handler untuk event 'LoadMyList'
    on<LoadMyList>((event, emit) {
      try {
        // Ambil data dari repository (ini adalah operasi sinkron/cepat)
        final list = myListRepository.getMyList();
        emit(MyListLoaded(myList: list));
      } catch (e) {
        // Jika terjadi error, kirim list kosong
        emit(const MyListLoaded(myList: []));
      }
    });

    // Handler untuk event 'RemoveFromMyList'
    on<RemoveFromMyList>((event, emit) async {
      try {
        // Hapus dari repository
        await myListRepository.deleteAnime(event.animeId);
        // Ambil lagi list yang sudah update dan emit
        add(LoadMyList());
      } catch (e) {
        // Jika gagal, tetap tampilkan list yang ada
        emit(MyListLoaded(myList: myListRepository.getMyList()));
      }
    });
  }
}