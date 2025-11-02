// ---------------------------------------------------
// lib/data/repositories/saran_kesan_repository.dart
// ---------------------------------------------------

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ta_teori/data/models/saran_kesan_model.dart';

class SaranKesanRepository {
  
  final Box<SaranKesan> _box = Hive.box<SaranKesan>('saranKesanBox');
  // Kita akan gunakan key statis, karena hanya ada 1 entri saran/kesan
  final String _entryKey = 'saranKesanEntry';

  // --- Fungsi Create / Update ---
  Future<void> saveSaranKesan(String saran, String kesan) async {
    final entry = SaranKesan(
      saran: saran,
      kesan: kesan,
      timestamp: DateTime.now(),
    );
    // 'put' akan menyimpan atau meng-update data di key tersebut
    await _box.put(_entryKey, entry);
  }

  // --- Fungsi Read (Get One) ---
  SaranKesan? getSaranKesan() {
    // Ambil data dari key statis kita
    return _box.get(_entryKey);
  }
}