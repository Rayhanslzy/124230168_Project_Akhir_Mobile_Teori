// ---------------------------------------------------
// lib/features/shell/cubit/shell_cubit.dart
// ---------------------------------------------------

import 'package:bloc/bloc.dart';

// State-nya hanyalah sebuah integer (angka)
// 0 = Home, 1 = Search, 2 = My List, 3 = Profile
class ShellCubit extends Cubit<int> {
  // State awalnya adalah 0 (Halaman Home)
  ShellCubit() : super(0);

  // Fungsi untuk mengubah halaman
  void changePage(int index) {
    emit(index); // 'emit' akan mengirim state (index) baru
  }
}