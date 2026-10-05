import 'package:dartz/dartz.dart';
import 'package:mierp_apps/core/error/failures.dart';
import 'package:mierp_apps/core/models/user_model.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserModel>> login(String email, String password);
  Future<Either<Failure, UserModel>> loginWithGoogle();
}
