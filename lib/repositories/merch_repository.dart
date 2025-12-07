import 'package:hive_flutter/hive_flutter.dart';
import '../models/merch_item_model.dart';

class MerchRepository {
  // Langsung akses box yang sudah dibuka di main.dart
  final Box<MerchItemModel> _merchBox = Hive.box<MerchItemModel>('merchBox');

  // Ambil Semua List (Diurutkan dari yang terbaru)
  List<MerchItemModel> getAllItems() {
    final list = _merchBox.values.toList();
    list.sort((a, b) => b.dateAdded.compareTo(a.dateAdded)); // Sort Descending
    return list;
  }

  // Simpan Barang
  Future<void> addItem(MerchItemModel item) async {
    await _merchBox.put(item.id, item);
  }

  // Hapus Barang
  Future<void> deleteItem(String id) async {
    await _merchBox.delete(id);
  }
}