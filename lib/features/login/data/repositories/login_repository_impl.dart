import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dartz/dartz.dart';
import 'package:mierp_apps/core/error/failures.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseAuth authFirebase = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore authStore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    try {
      UserCredential userCredential = await authFirebase.signInWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      DocumentSnapshot snapDoc = await authStore.collection('users').doc(uid).get();

      if (!snapDoc.exists) {
        return const Left(ValidationFailure('User tidak ditemukan di database.'));
      }
      final data = snapDoc.data() as Map<String, dynamic>;

      UserModel userModel = UserModel(
        uid: uid,
        email: data['email'],
        firstName: data['first_name'],
        lastName: data['last_name'],
        role: data['role'],
        allowGoogleLogin: data['allow_google_login']
      );
      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return const Left(ValidationFailure('Email belum terdaftar.'));
        case 'wrong-password':
        case 'invalid-credential':
          return const Left(ValidationFailure('Password salah.'));
        case 'invalid-email':
          return const Left(ValidationFailure('Format email tidak valid.'));
        default:
          return const Left(ServerFailure('Terjadi kesalahan autentikasi.'));
      }
    } catch (_) {
      return const Left(ServerFailure('Terjadi kesalahan server.'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginWithGoogle() async {
    try {
      await googleSignIn.initialize();
      final googleUser = await googleSignIn.authenticate(scopeHint: ['email']);
      
      if (googleUser == null) {
          return const Left(ValidationFailure('Login Google dibatalkan.'));
      }

      final email = googleUser.email;

      final query = await authStore.collection("users").where('email', isEqualTo: email).limit(1).get();

      if(query.docs.isEmpty){
         return const Left(ValidationFailure('Akun ini belum terdaftar.'));
      }

      final checkProvider = query.docs.first.data();

      if (checkProvider['allow_google_login'] == false) {
        return const Left(ValidationFailure('Akun ini tidak mengizinkan login Google.'));
      }

      final googleAutorization = await googleUser.authentication;
      final idToken = googleAutorization.idToken;

      if(idToken == null) {
        return const Left(ValidationFailure('Token Google tidak valid.'));
      }

      final googleCredential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await authFirebase.signInWithCredential(googleCredential);
      final uid = userCredential.user!.uid;
      final snapDoc = await authStore.collection('users').doc(uid).get();

      if(!snapDoc.exists) {
        return const Left(ValidationFailure('Data user tidak ditemukan di sistem.'));
      }

      final docJson = snapDoc.data() as Map<String, dynamic>;
      return Right(UserModel.fromJson(docJson));
    } catch(e) {
      return const Left(ServerFailure('Gagal melakukan login dengan Google.'));
    }
  }
}
