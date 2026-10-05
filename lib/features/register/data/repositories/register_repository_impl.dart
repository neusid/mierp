import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:mierp_apps/core/error/failures.dart';
import 'package:mierp_apps/features/register/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, UserCredential>> register(
      String email, String password, String firstName, String lastName, String role) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      
      final uid = userCredential.user!.uid;

      await firebaseStore.collection("users").doc(uid).set({
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'role': role,
        'allow_google_login': false
      });

      // Sign out immediately after registration to require login
      await firebaseAuth.signOut();

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return const Left(ValidationFailure('Password terlalu lemah. Minimal 6 karakter.'));
      } else if (e.code == 'email-already-in-use') {
        return const Left(ValidationFailure('Email sudah terdaftar.'));
      } else if (e.code == 'invalid-email') {
        return const Left(ValidationFailure('Format email tidak valid.'));
      }
      return const Left(ServerFailure('Gagal melakukan pendaftaran.'));
    } catch (_) {
      return const Left(ServerFailure('Terjadi kesalahan server saat mendaftar.'));
    }
  }
}
