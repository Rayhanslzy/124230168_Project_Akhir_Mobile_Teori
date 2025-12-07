import 'package:hive/hive.dart';

part 'my_anime_entry_model.g.dart';

@HiveType(typeId: 2)
class MyAnimeEntryModel extends HiveObject {
  @HiveField(0)
  final int animeId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String coverImageUrl;

  @HiveField(3)
  String status;

  @HiveField(4)
  int? userScore;

  @HiveField(5)
  int episodesWatched; 

  @HiveField(6)
  DateTime? startDate;

  @HiveField(7)
  DateTime? finishDate;

  @HiveField(8)
  int totalRewatches;

  @HiveField(9)
  String notes;

  // --- WAJIB ADA INI BIAR GAK NYAMPUR ---
  @HiveField(10)
  final String userId; 

  MyAnimeEntryModel({
    required this.animeId,
    required this.title,
    required this.coverImageUrl,
    required this.status,
    required this.userId, // Wajib diisi
    this.userScore,
    this.episodesWatched = 0,
    this.startDate,
    this.finishDate,
    this.totalRewatches = 0,
    this.notes = '',
  });
}