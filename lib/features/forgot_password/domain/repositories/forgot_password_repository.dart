import 'package:dartz/dartz.dart';
import 'package:mierp_apps/core/error/failures.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, void>> sendPasswordResetVerification(String email);
}
