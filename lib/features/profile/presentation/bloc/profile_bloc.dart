import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/data/login/login_repository.dart';

// --- EVENTS ---
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object> get props => [];
}

class ProfileStarted extends ProfileEvent {}

class ProfileLinkGoogleRequested extends ProfileEvent {}

class ProfileUnlinkGoogleRequested extends ProfileEvent {}

class ProfileDeleteAccountRequested extends ProfileEvent {}

class ProfileLogoutRequested extends ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final String firstName;
  final String lastName;

  const ProfileUpdateRequested({
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [firstName, lastName];
}

// --- STATE ---
enum ProfileStatus { initial, loading, success, failure, logoutSuccess, deleteSuccess }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String role;
  final String name;
  final String firstName;
  final String lastName;
  final String uid;
  final String email;
  final bool isVerif;
  final String errorMessage;
  final String successMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.role = "warehouse",
    this.name = "",
    this.firstName = "",
    this.lastName = "",
    this.uid = "",
    this.email = "",
    this.isVerif = true,
    this.errorMessage = "",
    this.successMessage = "",
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? role,
    String? name,
    String? firstName,
    String? lastName,
    String? uid,
    String? email,
    bool? isVerif,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      role: role ?? this.role,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      isVerif: isVerif ?? this.isVerif,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object> get props => [status, role, name, firstName, lastName, uid, email, isVerif, errorMessage, successMessage];
}

// --- BLOC ---
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final LoginRepository loginRepository;
  final UserDataController userDataController;

  ProfileBloc({
    required this.loginRepository,
    required this.userDataController,
  }) : super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileUpdateRequested>(_onUpdateRequested);
    on<ProfileLinkGoogleRequested>(_onLinkGoogleRequested);
    on<ProfileUnlinkGoogleRequested>(_onUnlinkGoogleRequested);
    on<ProfileDeleteAccountRequested>(_onDeleteAccountRequested);
    on<ProfileLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onStarted(ProfileStarted event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      UserModel? userModel = await userDataController.getDataUser();
      final fName = userModel.firstName ?? "";
      final lName = userModel.lastName ?? "";
      final fullName = (fName.isNotEmpty || lName.isNotEmpty)
          ? "$fName $lName".trim()
          : "";

      emit(state.copyWith(
        status: ProfileStatus.success,
        role: userModel.role ?? "warehouse",
        name: fullName,
        firstName: fName,
        lastName: lName,
        email: userModel.email ?? "",
        isVerif: userModel.allowGoogleLogin,
        uid: userModel.uid ?? "",
      ));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateRequested(ProfileUpdateRequested event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final uid = state.uid;
      if (uid.isNotEmpty) {
        try {
          await loginRepository.authStore.collection('users').doc(uid).update({
            'first_name': event.firstName,
            'last_name': event.lastName,
          }).timeout(const Duration(seconds: 4));
        } catch (_) {}
      }

      // Update local storage
      final current = await userDataController.getDataUser();
      final updated = UserModel(
        uid: current.uid,
        email: current.email,
        firstName: event.firstName,
        lastName: event.lastName,
        role: current.role,
        allowGoogleLogin: current.allowGoogleLogin,
      );
      await userDataController.setDataUser(updated);

      final fullName = "${event.firstName} ${event.lastName}".trim();
      emit(state.copyWith(
        status: ProfileStatus.success,
        name: fullName.isNotEmpty ? fullName : state.name,
        firstName: event.firstName,
        lastName: event.lastName,
        successMessage: "Profil berhasil diperbarui",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: "Gagal memperbarui profil: $e",
      ));
    }
  }

  Future<void> _onLinkGoogleRequested(ProfileLinkGoogleRequested event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await loginRepository.linkToAnotherAccount(state.uid);
      emit(state.copyWith(
        status: ProfileStatus.success,
        successMessage: "Linked account to Google",
        isVerif: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: "Failed to link account to Google",
      ));
    }
  }

  Future<void> _onUnlinkGoogleRequested(ProfileUnlinkGoogleRequested event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await loginRepository.unlinkFromGoogle(state.uid);
      
      // Update UserDataController so local cache knows it's unlinked
      UserModel? user = await userDataController.getDataUser();
      UserModel updatedUser = UserModel(
        uid: user.uid,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
        allowGoogleLogin: false,
      );
      await userDataController.setDataUser(updatedUser);

      emit(state.copyWith(
        status: ProfileStatus.success,
        successMessage: "Unlinked Google Account",
        isVerif: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: "Failed to unlink Google Account",
      ));
    }
  }

  Future<void> _onDeleteAccountRequested(ProfileDeleteAccountRequested event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await loginRepository.deleteAccount();
      emit(state.copyWith(status: ProfileStatus.deleteSuccess, successMessage: 'User deleted successfully.'));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: 'Error deleted account: $e'));
    }
  }

  Future<void> _onLogoutRequested(ProfileLogoutRequested event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await loginRepository.authFirebase.signOut();
      await loginRepository.googleSignIn.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      emit(state.copyWith(status: ProfileStatus.logoutSuccess));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: 'Error signing out: $e'));
    }
  }
}
