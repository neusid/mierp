import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/forgot_password/domain/usecases/do_reset_password.dart';

// --- EVENTS ---
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object> get props => [];
}

class ResetPasswordRequested extends ForgotPasswordEvent {
  final String email;

  const ResetPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
}

// --- STATES ---
abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;
  const ForgotPasswordSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;
  const ForgotPasswordFailure(this.message);
  @override
  List<Object> get props => [message];
}

// --- BLOC ---
class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final DoResetPassword doResetPassword;

  ForgotPasswordBloc({required this.doResetPassword}) : super(ForgotPasswordInitial()) {
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    
    final result = await doResetPassword(event.email);
    
    result.fold(
      (failure) => emit(ForgotPasswordFailure(failure.message)),
      (_) => emit(const ForgotPasswordSuccess('Email reset password telah dikirim! Silakan periksa inbox atau spam.')),
    );
  }
}
