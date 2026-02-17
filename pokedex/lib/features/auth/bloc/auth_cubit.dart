import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex/features/auth/data/auth_repository.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithGoogle();
      // State emission handled by listener
    } catch (e) {
      emit(AuthError('Failed to sign in: $e'));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    await _authRepository.signOut();
    // State emission handled by listener
  }
}
