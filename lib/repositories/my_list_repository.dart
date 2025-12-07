import 'package:hive_flutter/hive_flutter.dart';
import 'package:ta_teori/models/my_anime_entry_model.dart';

class MyListRepository {
  
  final Box<MyAnimeEntryModel> _myListBox = 
      Hive.box<MyAnimeEntryModel>('myAnimeEntryBox');

  // Kunci Unik: UserID + AnimeID
  String _generateKey(String userId, int animeId) {
    return '${userId}_$animeId';
  }

  Future<void> addOrUpdateAnime(MyAnimeEntryModel animeEntry) async {
    // Simpan pake kunci unik
    final key = _generateKey(animeEntry.userId, animeEntry.animeId);
    await _myListBox.put(key, animeEntry);
  }

  // --- BAGIAN PENTING: FILTER DATA ---
  List<MyAnimeEntryModel> getMyList(String userId) {
    // Cuma ambil yang userId-nya cocok
    return _myListBox.values.where((item) => item.userId == userId).toList();
  }

  Future<void> deleteAnime(String userId, int animeId) async {
    final key = _generateKey(userId, animeId);
    await _myListBox.delete(key);
  }

  bool isInList(String userId, int animeId) {
    final key = _generateKey(userId, animeId);
    return _myListBox.containsKey(key);
  }

  MyAnimeEntryModel? getEntry(String userId, int animeId) {
    final key = _generateKey(userId, animeId);
    return _myListBox.get(key);
  }
}