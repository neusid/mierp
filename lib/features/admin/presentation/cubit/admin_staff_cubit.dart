import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/services/tenant_service.dart';
import 'package:mierp_apps/features/admin/data/repositories/admin_staff_repository.dart';
import 'package:mierp_apps/features/admin/presentation/cubit/admin_staff_state.dart';

class AdminStaffCubit extends Cubit<AdminStaffState> {
  final AdminStaffRepository repository;

  AdminStaffCubit({required this.repository}) : super(AdminStaffInitial());

  Future<void> loadStaffList() async {
    emit(AdminStaffLoading());
    try {
      final adminId = await TenantService.getActiveAdminId();
      if (adminId.isEmpty) {
        emit(const AdminStaffFailure("Sesi Admin tidak valid."));
        return;
      }

      final staff = await repository.getStaffList(adminId);
      emit(AdminStaffLoaded(staffList: staff));
    } catch (e) {
      emit(AdminStaffFailure(e.toString()));
    }
  }

  Future<bool> createStaff({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    String? companyName,
  }) async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      if (adminId.isEmpty) {
        emit(const AdminStaffFailure("Sesi Admin tidak valid."));
        return false;
      }

      await repository.createStaffAccount(
        adminId: adminId,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
        companyName: companyName,
      );

      final updatedStaff = await repository.getStaffList(adminId);
      emit(AdminStaffLoaded(
        staffList: updatedStaff,
        successMessage: "Staf $firstName ($role) berhasil ditambahkan!",
      ));
      return true;
    } catch (e) {
      emit(AdminStaffFailure(e.toString()));
      return false;
    }
  }

  Future<void> deleteStaff(String staffUid) async {
    try {
      final adminId = await TenantService.getActiveAdminId();
      await repository.deleteStaff(staffUid);
      final updatedStaff = await repository.getStaffList(adminId);
      emit(AdminStaffLoaded(
        staffList: updatedStaff,
        successMessage: "Akun staf berhasil dihapus.",
      ));
    } catch (e) {
      emit(AdminStaffFailure(e.toString()));
    }
  }
}
