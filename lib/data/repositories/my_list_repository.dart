// ---------------------------------------------------
// lib/data/repositories/my_list_repository.dart
// ---------------------------------------------------

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ta_teori/data/models/my_anime_entry_model.dart';

class MyListRepository {
  
  // Ambil box yang akan kita buka di main.dart
  final Box<MyAnimeEntryModel> _myListBox = 
      Hive.box<MyAnimeEntryModel>('myAnimeEntryBox');

  // --- Fungsi Create / Update ---
  // (Fungsi 'put' di Hive akan otomatis meng-update jika key-nya sudah ada)
  Future<void> addOrUpdateAnime(MyAnimeEntryModel animeEntry) async {
    // Kita gunakan 'animeId' sebagai Key unik di dalam box
    await _myListBox.put(animeEntry.animeId, animeEntry);
  }

  // --- Fungsi Read (Get All) ---
  List<MyAnimeEntryModel> getMyList() {
    // .values mengembalikan semua data di dalam box
    return _myListBox.values.toList();
  }

  // --- Fungsi Delete ---
  Future<void> deleteAnime(int animeId) async {
    await _myListBox.delete(animeId);
  }

  // --- Fungsi Helper (Untuk cek apakah anime sudah ada di list) ---
  bool isInList(int animeId) {
    return _myListBox.containsKey(animeId);
  }

  // --- Fungsi Helper (Untuk ambil satu entry) ---
  MyAnimeEntryModel? getEntry(int animeId) {
    return _myListBox.get(animeId);
  }
}
