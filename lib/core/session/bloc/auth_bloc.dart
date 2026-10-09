import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/data/auth_session/auth_session_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthSessionRepository authSessionRepository;
  StreamSubscription? _userSubscription;

  AuthBloc({required this.authSessionRepository}) : super(AuthInitial()) {
    on<AuthUserChanged>(_onUserChanged);

    // Initial check
    final initialUser = authSessionRepository.currentUser;
    add(AuthUserChanged(initialUser));

    // Listen to changes
    _userSubscription = authSessionRepository.streamUser.listen((user) {
      add(AuthUserChanged(user));
    });
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
