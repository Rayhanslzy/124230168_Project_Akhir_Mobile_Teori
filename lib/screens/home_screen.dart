// ---------------------------------------------------------
// lib/screens/home_screen.dart
// ---------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/anime_repository.dart';
import '../logic/home_bloc.dart';
import '../logic/location_cubit.dart'; // <--- IMPORT CUBIT LOKASI
import '../models/anime_model.dart';
import '../widgets/anime_card.dart';
import 'anime_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        animeRepository: RepositoryProvider.of<AnimeRepository>(context),
      )..add(const FetchHomeData()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // UPDATE TITLE BIAR ADA LOKASI
        title: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state is LocationLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AniList Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.blueAccent),
                      const SizedBox(width: 4),
                      Text(
                        "${state.city} • ${state.zone}", 
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              );
            }
            return const Text('AniList Home', style: TextStyle(fontWeight: FontWeight.bold));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeBloc>().add(const FetchHomeData(isRefresh: true));
              // Refresh Lokasi juga kalau mau
              context.read<LocationCubit>().detectLocation(); 
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async => context.read<HomeBloc>().add(const FetchHomeData(isRefresh: true)),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("TRENDING NOW"),
                    _buildHorizontalList(context, state.trending),

                    _buildSectionHeader("POPULAR THIS SEASON"),
                    _buildHorizontalList(context, state.thisSeason),

                    _buildSectionHeader("UPCOMING NEXT SEASON"),
                    _buildHorizontalList(context, state.nextSeason),

                    _buildSectionHeader("ALL TIME POPULAR"),
                    _buildHorizontalList(context, state.allTime),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }

          if (state is HomeError) {
            return Center(child: Text("Error: ${state.message}", style: const TextStyle(color: Colors.red)));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: Colors.white, 
        ),
      ),
    );
  }

  Widget _buildHorizontalList(BuildContext context, List<AnimeModel> animeList) {
    return SizedBox(
      height: 230, 
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal, 
        physics: const BouncingScrollPhysics(), 
        itemCount: animeList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final anime = animeList[index];
          return SizedBox(
            width: 125, 
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AnimeDetailScreen(animeId: anime.id),
                  ),
                );
              },
              child: AnimeCard(anime: anime),
            ),
          );
        },
      ),
    );
  }
}