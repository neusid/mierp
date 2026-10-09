import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/core/session/bloc/auth_bloc.dart';
import 'package:mierp_apps/core/session/bloc/auth_state.dart';
import 'package:mierp_apps/features/onboarding/presentation/onboarding_service.dart';

// --- EVENTS ---
abstract class SplashEvent extends Equatable {
  const SplashEvent();
  @override
  List<Object> get props => [];
}

class SplashStarted extends SplashEvent {}

// --- STATES ---
abstract class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}
class SplashNavigateToOnboarding extends SplashState {}
class SplashNavigateToLogin extends SplashState {}
class SplashNavigateToWarehouse extends SplashState {}
class SplashNavigateToFinance extends SplashState {}

// --- BLOC ---
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthBloc authBloc;
  final OnboardingService onboardingService;

  SplashBloc({
    required this.authBloc,
    required this.onboardingService,
  }) : super(SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    final isFirst = true;
    
    if (isFirst) {
      await Future.delayed(const Duration(seconds: 2));
      emit(SplashNavigateToOnboarding());
    } else {
      final prefs = await SharedPreferences.getInstance();
      await Future.delayed(const Duration(seconds: 2));

      if (authBloc.state is! AuthAuthenticated) {
        emit(SplashNavigateToLogin());
        return;
      }

      final dataUserRaw = prefs.getString("user");
      if (dataUserRaw != null) {
        try {
          Map<String, dynamic> dataUserJson = jsonDecode(dataUserRaw);
          final dataUser = UserModel.fromJson(dataUserJson);
          if (dataUser.role == "warehouse") {
            emit(SplashNavigateToWarehouse());
            return;
          }
        } catch (e) {
          // Fallback to finance or login if parsing fails
        }
      }
      emit(SplashNavigateToFinance());
    }
  }
}
