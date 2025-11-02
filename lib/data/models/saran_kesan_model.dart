// ---------------------------------------------------
// lib/data/models/saran_kesan_model.dart (Versi Final - Bersih)
// ---------------------------------------------------
import 'package:hive/hive.dart';

part 'saran_kesan_model.g.dart';

@HiveType(typeId: 1)
class SaranKesan extends HiveObject {
  @HiveField(0)
  final String saran;

  @HiveField(1)
  final String kesan;

  @HiveField(2)
  final DateTime timestamp;

  SaranKesan({
    required this.saran,
    required this.kesan,
    required this.timestamp,
  });
}