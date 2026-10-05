import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/domain/credential/repository/credential_repository.dart';
import 'package:mierp_apps/features/login/domain/usecases/do_login.dart';

// --- EVENTS ---
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginLoadCredential extends LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final bool saveCredential;

  const LoginSubmitted({
    required this.email,
    required this.password,
    required this.saveCredential,
  });

  @override
  List<Object> get props => [email, password, saveCredential];
}

class LoginWithGoogleSubmitted extends LoginEvent {}

// --- STATES ---
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  final String savedEmail;
  final bool saveCredential;
  const LoginInitial({this.savedEmail = '', this.saveCredential = false});
  @override
  List<Object> get props => [savedEmail, saveCredential];
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String role;
  const LoginSuccess(this.role);
  @override
  List<Object> get props => [role];
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
  @override
  List<Object> get props => [message];
}

// --- BLOC ---
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DoLogin doLogin;
  final DoLoginWithGoogle doLoginWithGoogle;
  final CredentialRepository credentialRepository;
  final UserDataController userDataController;

  LoginBloc({
    required this.doLogin,
    required this.doLoginWithGoogle,
    required this.credentialRepository,
    required this.userDataController,
  }) : super(const LoginInitial()) {
    on<LoginLoadCredential>(_onLoadCredential);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginWithGoogleSubmitted>(_onLoginWithGoogleSubmitted);
  }

  Future<void> _onLoadCredential(
    LoginLoadCredential event,
    Emitter<LoginState> emit,
  ) async {
    final data = await credentialRepository.loadCredentialUser();
    if (data.isSave) {
      emit(LoginInitial(savedEmail: data.email ?? '', saveCredential: true));
    } else {
      emit(const LoginInitial());
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    
    final result = await doLogin(event.email, event.password);
    
    await result.fold(
      (failure) async => emit(LoginFailure(failure.message)),
      (user) async {
        final dataUserRaw = jsonEncode(user);
        await credentialRepository.setDataUser(dataUserRaw);
        await userDataController.setDataUser(user);

        if (event.saveCredential) {
          await credentialRepository.setCredentialUser(event.email, true);
        } else {
          await credentialRepository.deletePreference();
        }

        emit(LoginSuccess(user.role ?? ''));
      },
    );
  }

  Future<void> _onLoginWithGoogleSubmitted(
    LoginWithGoogleSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    
    final result = await doLoginWithGoogle();
    
    await result.fold(
      (failure) async => emit(LoginFailure(failure.message)),
      (user) async {
        final dataUserRaw = jsonEncode(user);
        await credentialRepository.setDataUser(dataUserRaw);
        await userDataController.setDataUser(user);
        
        await Future.delayed(const Duration(seconds: 3));
        emit(LoginSuccess(user.role ?? ''));
      },
    );
  }
}
