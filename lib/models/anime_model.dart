// ---------------------------------------------------
// lib/models/anime_model.dart
// ---------------------------------------------------

class AnimeModel {
  final int id;
  final String title;
  final String coverImageUrl;
  final int? averageScore;
  final String? description;
  final List<String>? genres;
  
  final String? status;
  final int? episodes;
  final String? season;
  final int? seasonYear;
  final String? trailerUrl;
  final List<CharacterModel>? characters;
  final List<AnimeModel>? recommendations;
  
  // --- DATA BARU: JADWAL TAYANG ---
  final int? nextAiringEpisode; // Episode ke berapa (misal: 5)
  final int? airingAt;          // Detik (Timestamp) kapan tayang

  AnimeModel({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    this.averageScore,
    this.description,
    this.genres,
    this.status,
    this.episodes,
    this.season,
    this.seasonYear,
    this.trailerUrl,
    this.characters,
    this.recommendations,
    this.nextAiringEpisode,
    this.airingAt,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    String? trailer;
    if (json['trailer'] != null && json['trailer']['site'] == 'youtube') {
      trailer = 'https://www.youtube.com/watch?v=${json['trailer']['id']}';
    }

    List<CharacterModel>? chars;
    if (json['characters'] != null && json['characters']['nodes'] != null) {
      chars = (json['characters']['nodes'] as List)
          .map((c) => CharacterModel.fromJson(c))
          .toList();
    }

    List<AnimeModel>? recs;
    if (json['recommendations'] != null && json['recommendations']['nodes'] != null) {
      recs = (json['recommendations']['nodes'] as List)
          .where((r) => r['mediaRecommendation'] != null)
          .map((r) => AnimeModel.fromJson(r['mediaRecommendation']))
          .toList();
    }

    // Ambil data Next Episode
    int? nextEp;
    int? airTime;
    if (json['nextAiringEpisode'] != null) {
      nextEp = json['nextAiringEpisode']['episode'];
      airTime = json['nextAiringEpisode']['airingAt'];
    }

    return AnimeModel(
      id: json['id'],
      title: json['title']['romaji'] ?? json['title']['english'] ?? 'No Title',
      coverImageUrl: json['coverImage']['large'] ?? '',
      averageScore: json['averageScore'],
      description: json['description'],
      genres: json['genres'] != null
          ? List<String>.from(json['genres'].map((g) => g.toString()))
          : [],
      status: json['status'],
      episodes: json['episodes'],
      season: json['season'],
      seasonYear: json['seasonYear'],
      trailerUrl: trailer,
      characters: chars,
      recommendations: recs,
      nextAiringEpisode: nextEp,
      airingAt: airTime,
    );
  }
}

class CharacterModel {
  final String name;
  final String imageUrl;

  CharacterModel({required this.name, required this.imageUrl});

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      name: json['name']['full'],
      imageUrl: json['image']['large'] ?? '',
    );
  }
}