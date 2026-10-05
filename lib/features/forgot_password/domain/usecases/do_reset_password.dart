import 'package:dartz/dartz.dart';
import 'package:mierp_apps/core/error/failures.dart';
import 'package:mierp_apps/features/forgot_password/domain/repositories/forgot_password_repository.dart';

class DoResetPassword {
  final ForgotPasswordRepository repository;

  DoResetPassword(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.sendPasswordResetVerification(email);
  }
}
