import 'package:hive/hive.dart';

part 'merch_item_model.g.dart';

@HiveType(typeId: 3) // ID 3 karena 0,1,2 udah kepake
class MerchItemModel extends HiveObject {
  @HiveField(0)
  final String id; // ID Unik

  @HiveField(1)
  final String itemName; // Nama Barang

  @HiveField(2)
  final double priceInJpy; // Harga Yen

  @HiveField(3)
  final String targetCurrency; // Mata uang tujuan (IDR, USD, dll)

  @HiveField(4)
  final double convertedPrice; // Harga hasil konversi

  @HiveField(5)
  final DateTime dateAdded;

  MerchItemModel({
    required this.id,
    required this.itemName,
    required this.priceInJpy,
    required this.targetCurrency,
    required this.convertedPrice,
    required this.dateAdded,
  });
}