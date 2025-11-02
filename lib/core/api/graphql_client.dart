// ---------------------------------------------------
// lib/core/api/graphql_client.dart
// ---------------------------------------------------

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLClientConfig {
  // 1. URL endpoint untuk AniList API
  static final HttpLink _httpLink = HttpLink(
    'https://graphql.anilist.co',
  );

  // 2. Konfigurasi Klien
  // ValueNotifier<GraphQLClient> memberi tahu widget 
  // di tree untuk update jika klien berubah
  static ValueNotifier<GraphQLClient> initializeClient() {
    
    // Kita tidak perlu token (AuthLink) untuk mengambil data PUBLIK
    // Kita hanya perlu HttpLink
    final Link link = _httpLink;

    return ValueNotifier(
      GraphQLClient(
        link: link,
        // 3. Strategi Cache: Cache first, lalu network
        // Ini akan membuat aplikasi terasa cepat.
        // Data akan diambil dari cache dulu, lalu update dari network.
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
  }
}