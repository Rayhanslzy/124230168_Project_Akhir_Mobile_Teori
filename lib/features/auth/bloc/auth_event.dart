// ---------------------------------------------------
// lib/features/auth/bloc/auth_event.dart (Versi Final - Sudah Diformat)
// ---------------------------------------------------

part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Event saat tombol login ditekan
class LoginButtonPressed extends AuthEvent {
  final String username;
  final String password;

  const LoginButtonPressed({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

// Event saat tombol register ditekan
class RegisterButtonPressed extends AuthEvent {
  final String username;
  final String password;

  const RegisterButtonPressed({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

// Event saat tombol logout ditekan
class LogoutButtonPressed extends AuthEvent {}