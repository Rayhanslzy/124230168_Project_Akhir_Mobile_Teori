// ---------------------------------------------------
// lib/data/providers/anilist_api_provider.dart (Versi Final)
// ---------------------------------------------------

import 'package:graphql_flutter/graphql_flutter.dart';

class AnilistApiProvider {
  final GraphQLClient client;

  AnilistApiProvider({required this.client});

  // --- FUNGSI #1: UNTUK HALAMAN HOME ---
  Future<Map<String, dynamic>> getPopularAnime() async {
    // 1. Ini adalah "script" query GraphQL kita
    // Kita minta 20 anime, diurutkan berdasarkan popularitas
    final String queryString = """
      query {
        Page(page: 1, perPage: 20) {
          media(type: ANIME, sort: [POPULARITY_DESC]) {
            id
            title {
              romaji
              english
            }
            coverImage {
              large
            }
            averageScore
          }
        }
      }
    """;

    // 2. Siapkan opsi query
    final QueryOptions options = QueryOptions(
      document: gql(queryString),
    );

    // 3. Panggil API
    final QueryResult result = await client.query(options);

    // 4. Cek jika ada error
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    // 5. Kembalikan data mentahnya (dalam bentuk Map)
    return result.data!;
  }

  // --- FUNGSI #2: UNTUK HALAMAN SEARCH ---
  Future<Map<String, dynamic>> searchAnime(String query) async {
    // 1. Query ini sekarang menerima "variables"
    final String queryString = """
      query (\$search: String) { 
        Page(page: 1, perPage: 20) {
          media(type: ANIME, search: \$search, sort: [POPULARITY_DESC]) {
            id
            title {
              romaji
              english
            }
            coverImage {
              large
            }
            averageScore
          }
        }
      }
    """;

    // 2. Siapkan opsi query dengan variables
    final QueryOptions options = QueryOptions(
      document: gql(queryString),
      variables: {
        'search': query, // Masukkan query dari pengguna ke variable
      },
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    return result.data!;
  }

  // --- FUNGSI #3: UNTUK HALAMAN DETAIL ---
  Future<Map<String, dynamic>> getAnimeDetail(int animeId) async {
    // 1. Query ini meminta 'description' dan 'genres'
    // dan menggunakan $id sebagai variabel
    final String queryString = """
      query (\$id: Int) {
        Media(id: \$id, type: ANIME) {
          id
          title {
            romaji
            english
          }
          coverImage {
            large
          }
          averageScore
          description(asHtml: false)
          genres
        }
      }
    """;

    // 2. Siapkan opsi query dengan variables
    final QueryOptions options = QueryOptions(
      document: gql(queryString),
      variables: {
        'id': animeId, // Masukkan id anime yang diminta
      },
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    // 3. Kembalikan data 'Media' (bukan 'Page' lagi)
    return result.data!['Media'];
  }
}