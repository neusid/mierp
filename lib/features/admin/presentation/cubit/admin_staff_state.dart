import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/user_model.dart';

abstract class AdminStaffState extends Equatable {
  const AdminStaffState();

  @override
  List<Object?> get props => [];
}

class AdminStaffInitial extends AdminStaffState {}

class AdminStaffLoading extends AdminStaffState {}

class AdminStaffLoaded extends AdminStaffState {
  final List<UserModel> staffList;
  final String? successMessage;

  const AdminStaffLoaded({
    required this.staffList,
    this.successMessage,
  });

  int get financeCount =>
      staffList.where((s) => s.role?.toLowerCase() == 'finance').length;

  int get warehouseCount =>
      staffList.where((s) => s.role?.toLowerCase() == 'warehouse').length;

  @override
  List<Object?> get props => [staffList, successMessage];
}

class AdminStaffFailure extends AdminStaffState {
  final String message;

  const AdminStaffFailure(this.message);

  @override
  List<Object?> get props => [message];
}
