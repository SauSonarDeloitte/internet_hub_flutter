import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../repository/auth/auth_repository.dart';
import '../../../repository/base_repository.dart';
import '../../../shared/models/user_model.dart';
import '../../../utils/logger/talker_config.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    TalkerConfig.info('Login requested for: ${event.email}');

    final result = await _authRepository.login(event.email, event.password);

    switch (result) {
      case Success<UserModel>(:final data):
        TalkerConfig.info('Login successful');
        emit(AuthAuthenticated(data));
      case Failure<UserModel>(:final message):
        TalkerConfig.warning('Login failed: $message');
        emit(AuthError(message));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    TalkerConfig.info('Logout requested');
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    TalkerConfig.info('Checking authentication status');
    final result = await _authRepository.getCurrentUser();

    switch (result) {
      case Success<UserModel?>(:final data):
        if (data != null) {
          TalkerConfig.info('User is authenticated: ${data.name}');
          emit(AuthAuthenticated(data));
        } else {
          TalkerConfig.info('User is not authenticated');
          emit(const AuthUnauthenticated());
        }
      case Failure<UserModel?>():
        emit(const AuthUnauthenticated());
    }
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String?;
      if (type == 'authenticated') {
        final user = UserModel.fromJson(json['user'] as Map<String, dynamic>);
        return AuthAuthenticated(user);
      }
      return const AuthUnauthenticated();
    } catch (e) {
      TalkerConfig.error('Error deserializing auth state: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthAuthenticated) {
      return {
        'type': 'authenticated',
        'user': state.user.toJson(),
      };
    }
    return {'type': 'unauthenticated'};
  }
}
