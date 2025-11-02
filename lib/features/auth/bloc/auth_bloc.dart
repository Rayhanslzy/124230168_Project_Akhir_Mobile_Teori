// ---------------------------------------------------
// lib/features/auth/bloc/auth_bloc.dart (Versi Final - Perbaikan Import)
// ---------------------------------------------------

import 'package:bloc/bloc.dart';
// KOREKSI ADA DI SINI: 'package:' BUKAN 'package.'
import 'package:equatable/equatable.dart';
import 'package:ta_teori/data/models/user_model.dart';
import 'package:ta_teori/data/repositories/auth_repository.dart';

part 'auth_event.dart'; // Hubungkan ke file event
part 'auth_state.dart'; // Hubungkan ke file state

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // --- Handler untuk Event Login ---
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading()); // 1. Tampilkan loading
      try {
        // 2. Panggil repository
        final user = await authRepository.login(
          event.username,
          event.password,
        );
        // 3. Jika sukses, emit state sukses
        emit(AuthAuthenticated(user: user));
      } catch (e) {
        // 4. Jika gagal (misal: "Password salah"), emit state error
        emit(AuthError(message: e.toString().replaceFirst("Exception: ", "")));
      }
    });

    // --- Handler untuk Event Register ---
    on<RegisterButtonPressed>((event, emit) async {
      emit(AuthLoading()); // 1. Tampilkan loading
      try {
        // 2. Panggil repository untuk register
        await authRepository.register(
          event.username,
          event.password,
        );

        // 3. Langsung login setelah register
        final user = await authRepository.login(
          event.username,
          event.password,
        );

        // 4. Emit state sukses
        emit(AuthAuthenticated(user: user));
      } catch (e) {
        // 5. Jika gagal (misal: "Username sudah ada"), emit state error
        emit(AuthError(message: e.toString().replaceFirst("Exception: ", "")));
      }
    });

    // --- Handler untuk Event Logout ---
    on<LogoutButtonPressed>((event, emit) async {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    });
  }
}