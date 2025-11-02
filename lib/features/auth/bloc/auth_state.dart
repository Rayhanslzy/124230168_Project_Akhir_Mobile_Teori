// ---------------------------------------------------
// lib/features/auth/bloc/auth_state.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// State awal, belum login
class AuthInitial extends AuthState {}

// State saat sedang memproses login/register
class AuthLoading extends AuthState {}

// State saat berhasil login/register
class AuthAuthenticated extends AuthState {
  // Kita butuh import User, tapi didapat dari 'auth_bloc.dart'
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

// State saat logout
class AuthUnauthenticated extends AuthState {}

// State saat terjadi error
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}