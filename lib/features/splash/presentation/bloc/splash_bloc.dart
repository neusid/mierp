import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/core/session/bloc/auth_bloc.dart';
import 'package:mierp_apps/core/session/bloc/auth_event.dart';
import 'package:mierp_apps/core/session/bloc/auth_state.dart';
import 'package:mierp_apps/features/onboarding/presentation/onboarding_service.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:mierp_apps/core/services/tenant_service.dart';

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
class SplashNavigateToAdmin extends SplashState {}

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
    final prefs = await SharedPreferences.getInstance();
    final isFirst = await onboardingService.isFirstLaunch();
    
    // Safely verify or seed master Admin account in background
    TenantService.ensureDefaultAdminAccount();

    await Future.delayed(const Duration(seconds: 2));

    if (isFirst) {
      await onboardingService.completeFirstLaunch();
      emit(SplashNavigateToOnboarding());
      return;
    }

    // Check Firebase Auth current user and local session
    final currentUser = FirebaseAuth.instance.currentUser;
    final dataUserRaw = prefs.getString("user");

    // If neither Firebase Auth nor local session has data, go to login
    if (currentUser == null && dataUserRaw == null) {
      emit(SplashNavigateToLogin());
      return;
    }

    // Ensure AuthBloc is synced with active Firebase user
    if (currentUser != null && authBloc.state is! AuthAuthenticated) {
      authBloc.add(AuthUserChanged(currentUser));
    }

    // Route by saved user role in SharedPreferences
    if (dataUserRaw != null) {
      try {
        final Map<String, dynamic> dataUserJson = jsonDecode(dataUserRaw);
        final dataUser = UserModel.fromJson(dataUserJson);
        if (dataUser.isAdmin) {
          sl<NotificationCubit>().init("admin");
          emit(SplashNavigateToAdmin());
          return;
        } else if (dataUser.isWarehouse) {
          sl<NotificationCubit>().init("warehouse");
          emit(SplashNavigateToWarehouse());
          return;
        } else if (dataUser.isFinance) {
          sl<NotificationCubit>().init("finance");
          emit(SplashNavigateToFinance());
          return;
        }
      } catch (_) {
        // Fallback to Firestore check below
      }
    }

    // If local session lacked role but Firebase user is active, fetch from Firestore
    if (currentUser != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          data['uid'] = currentUser.uid;
          final roleStr = data['role']?.toString().toLowerCase() ?? '';
          final isExecutiveAdmin =
              roleStr == 'admin' || roleStr == 'superadmin' || roleStr == 'super_admin';
          if ((data['admin_id'] == null || data['admin_id'].toString().isEmpty) && isExecutiveAdmin) {
            data['admin_id'] = currentUser.uid;
          }
          final userModel = UserModel.fromJson(data);
          await prefs.setString('user', jsonEncode(userModel.toJson()));
          await sl<UserDataController>().setDataUser(userModel);

          if (userModel.isAdmin) {
            sl<NotificationCubit>().init("admin");
            emit(SplashNavigateToAdmin());
            return;
          } else if (userModel.isWarehouse) {
            sl<NotificationCubit>().init("warehouse");
            emit(SplashNavigateToWarehouse());
            return;
          } else {
            sl<NotificationCubit>().init("finance");
            emit(SplashNavigateToFinance());
            return;
          }
        }
      } catch (_) {}
    }

    emit(SplashNavigateToLogin());
  }
}
