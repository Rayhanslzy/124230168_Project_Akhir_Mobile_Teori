// ---------------------------------------------------
// lib/data/models/anime_model.dart (Update)
// ---------------------------------------------------

class AnimeModel {
  final int id;
  final String title;
  final String coverImageUrl;
  final int? averageScore; // Skor rata-rata (0-100)
  
  // --- FIELD BARU (Nullable) ---
  final String? description; // Sinopsis/Deskripsi
  final List<String>? genres; // List genre

  AnimeModel({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    this.averageScore,
    this.description, // Tambah di constructor
    this.genres,        // Tambah di constructor
  });

  // Factory constructor untuk mengubah JSON (Map) dari API menjadi Objek AnimeModel
  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    
    // Konversi 'genres' dari List<dynamic> ke List<String>
    List<String>? genreList;
    if (json['genres'] != null) {
      // Kita ubah (List<dynamic>) [ "Action", "Adventure" ] 
      // menjadi (List<String>) [ "Action", "Adventure" ]
      genreList = List<String>.from(json['genres'].map((g) => g.toString()));
    }

    return AnimeModel(
      id: json['id'],
      title: json['title']['romaji'] ?? json['title']['english'] ?? 'No Title',
      coverImageUrl: json['coverImage']['large'] ?? '',
      averageScore: json['averageScore'],
      
      // --- Parsing Data BARU ---
      description: json['description'], // Akan null jika tidak ada
      genres: genreList,            // Akan null jika tidak ada
    );
  }
}