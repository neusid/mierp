import 'package:dartz/dartz.dart';
import 'package:mierp_apps/core/error/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterRepository {
  Future<Either<Failure, UserCredential>> register(
      String email, String password, String firstName, String lastName, String role);
}
