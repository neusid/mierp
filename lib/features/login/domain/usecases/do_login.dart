import 'package:dartz/dartz.dart';
import 'package:mierp_apps/core/error/failures.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/features/login/domain/repositories/login_repository.dart';

class DoLogin {
  final LoginRepository repository;

  DoLogin(this.repository);

  Future<Either<Failure, UserModel>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}

class DoLoginWithGoogle {
  final LoginRepository repository;

  DoLoginWithGoogle(this.repository);

  Future<Either<Failure, UserModel>> call() async {
    return await repository.loginWithGoogle();
  }
}
