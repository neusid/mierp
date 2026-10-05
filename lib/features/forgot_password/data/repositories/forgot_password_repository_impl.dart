import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:mierp_apps/core/error/failures.dart';
import 'package:mierp_apps/features/forgot_password/domain/repositories/forgot_password_repository.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Either<Failure, void>> sendPasswordResetVerification(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Left(ValidationFailure('Email tidak ditemukan.'));
      }
      return const Left(ServerFailure('Gagal mengirim email reset password.'));
    } catch (_) {
      return const Left(ServerFailure('Terjadi kesalahan tidak terduga.'));
    }
  }
}
