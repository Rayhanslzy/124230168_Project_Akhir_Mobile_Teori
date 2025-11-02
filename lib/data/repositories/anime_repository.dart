// ---------------------------------------------------
// lib/data/repositories/anime_repository.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

import 'package:ta_teori/data/models/anime_model.dart';
import 'package:ta_teori/data/providers/anilist_api_provider.dart';

class AnimeRepository {
  final AnilistApiProvider apiProvider;

  AnimeRepository({required this.apiProvider});

  // --- FUNGSI #1: UNTUK HALAMAN HOME (YANG HILANG) ---
  Future<List<AnimeModel>> getPopularAnime() async {
    try {
      // 1. Minta data mentah
      final data = await apiProvider.getPopularAnime();

      // 2. Akses list 'media' dari dalam data JSON
      // data -> Page -> media
      final List mediaList = data['Page']['media'];

      // 3. Ubah setiap item di 'mediaList' menjadi AnimeModel
      // menggunakan factory 'fromJson' yang kita buat tadi
      return mediaList.map((item) => AnimeModel.fromJson(item)).toList();
    } catch (e) {
      // Tangani error
      throw Exception('Gagal memuat data anime: $e');
    }
  }

  // --- FUNGSI #2: UNTUK HALAMAN SEARCH (YANG HILANG) ---
  Future<List<AnimeModel>> searchAnime(String query) async {
    try {
      // 1. Panggil fungsi search di provider
      final data = await apiProvider.searchAnime(query);

      // 2. Logika parsing-nya sama persis
      final List mediaList = data['Page']['media'];

      return mediaList.map((item) => AnimeModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Gagal mencari anime: $e');
    }
  }

  // --- FUNGSI #3: UNTUK HALAMAN DETAIL (YANG SUDAH ADA) ---
  Future<AnimeModel> getAnimeDetail(int animeId) async {
    try {
      // 1. Panggil fungsi detail di provider
      final data = await apiProvider.getAnimeDetail(animeId);

      // 2. Data yang kembali adalah 1 objek 'Media', bukan list
      // Kita langsung ubah menjadi AnimeModel
      return AnimeModel.fromJson(data);
    } catch (e) {
      throw Exception('Gagal memuat detail anime: $e');
    }
  }
}