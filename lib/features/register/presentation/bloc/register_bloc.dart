import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/register/domain/usecases/do_register.dart';

// --- EVENTS ---
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String role;
  final String? companyName;

  const RegisterSubmitted({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.role = 'admin',
    this.companyName,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName, role, companyName];
}

// --- STATES ---
abstract class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  const RegisterSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class RegisterFailure extends RegisterState {
  final String message;
  const RegisterFailure(this.message);
  @override
  List<Object> get props => [message];
}

// --- BLOC ---
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final DoRegister doRegister;

  RegisterBloc({required this.doRegister}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    
    final result = await doRegister(
      event.email, 
      event.password, 
      event.firstName, 
      event.lastName, 
      event.role,
      companyName: event.companyName,
    );
    
    result.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (_) => emit(const RegisterSuccess('Pendaftaran berhasil! Silakan login.')),
    );
  }
}
