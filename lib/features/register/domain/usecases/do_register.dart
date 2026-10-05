import 'package:dartz/dartz.dart';
import 'package:mierp_apps/core/error/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mierp_apps/features/register/domain/repositories/register_repository.dart';

class DoRegister {
  final RegisterRepository repository;

  DoRegister(this.repository);

  Future<Either<Failure, UserCredential>> call(
      String email, String password, String firstName, String lastName, String role) async {
    return await repository.register(email, password, firstName, lastName, role);
  }
}
