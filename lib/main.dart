// ---------------------------------------------------
// lib/main.dart
// ---------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tzdata;
// IMPORT WAJIB BUAT FORMAT TANGGAL:
import 'package:intl/date_symbol_data_local.dart'; 

// Services
import 'services/notification_service.dart';
import 'services/graphql_client.dart';
import 'services/anilist_api_provider.dart';
import 'services/location_service.dart';

// Models
import 'models/user_model.dart';
import 'models/my_anime_entry_model.dart';
import 'models/merch_item_model.dart';

// Repositories
import 'repositories/auth_repository.dart';
import 'repositories/anime_repository.dart';
import 'repositories/my_list_repository.dart';
import 'repositories/search_history_repository.dart';
import 'repositories/merch_repository.dart';

// Logic (BLoC)
import 'logic/auth_bloc.dart';
import 'logic/my_list_bloc.dart';
import 'logic/merch_bloc.dart';
import 'logic/location_cubit.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // --- FIX ERROR LOCALE DI SINI ---
  // Kita inisialisasi data formatting buat Bahasa Indonesia ('id_ID')
  await initializeDateFormatting('id_ID', null);

  tzdata.initializeTimeZones();
  await NotificationService().init();
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(MyAnimeEntryModelAdapter());
  Hive.registerAdapter(MerchItemModelAdapter());

  // Open Boxes
  await Hive.openBox<User>('userBox');
  await Hive.openBox<MyAnimeEntryModel>('myAnimeEntryBox');
  await Hive.openBox('graphqlClientStore');
  await Hive.openBox<String>('searchHistoryBox');
  await Hive.openBox('sessionBox'); 
  await Hive.openBox<MerchItemModel>('merchBox');

  final graphqlBox = Hive.box('graphqlClientStore');
  final client = GraphQLClientConfig.initializeClient(graphqlBox);

  runApp(MyApp(graphqlClient: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> graphqlClient;

  const MyApp({super.key, required this.graphqlClient});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: graphqlClient,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
          RepositoryProvider<AnilistApiProvider>(create: (context) {
            final client = graphqlClient.value;
            return AnilistApiProvider(client: client);
          }),
          RepositoryProvider<AnimeRepository>(create: (context) => AnimeRepository(apiProvider: context.read<AnilistApiProvider>())),
          RepositoryProvider<MyListRepository>(create: (_) => MyListRepository()),
          RepositoryProvider<SearchHistoryRepository>(create: (_) => SearchHistoryRepository()),
          RepositoryProvider<MerchRepository>(create: (_) => MerchRepository()),
          RepositoryProvider<LocationService>(create: (_) => LocationService()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())..add(AuthCheckSession()), 
            ),
            BlocProvider<MyListBloc>(
              create: (context) => MyListBloc(myListRepository: context.read<MyListRepository>()), 
            ),
            BlocProvider<MerchBloc>(
              create: (context) => MerchBloc(merchRepository: context.read<MerchRepository>())..add(LoadMerchList()), 
            ),
            BlocProvider<LocationCubit>(
              create: (context) => LocationCubit(locationService: context.read<LocationService>())..detectLocation(),
            ),
          ],
          child: MaterialApp(
            title: 'Anime App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
            home: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  context.read<MyListBloc>().add(LoadMyList(userId: state.user.username));
                } else if (state is AuthUnauthenticated) {
                  context.read<MyListBloc>().add(ClearMyList());
                }
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) return const MainShell();
                  return const LoginPage();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}