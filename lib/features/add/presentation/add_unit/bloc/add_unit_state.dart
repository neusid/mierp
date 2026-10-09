import 'package:equatable/equatable.dart';

enum AddUnitStatus { initial, loading, success, failure }

class AddUnitState extends Equatable {
  final AddUnitStatus status;
  final String errorMessage;
  final String successMessage;

  const AddUnitState({
    this.status = AddUnitStatus.initial,
    this.errorMessage = '',
    this.successMessage = '',
  });

  AddUnitState copyWith({
    AddUnitStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return AddUnitState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        successMessage,
      ];
}
