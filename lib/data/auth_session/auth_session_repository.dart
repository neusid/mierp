
import 'package:firebase_auth/firebase_auth.dart';

class AuthSessionRepository {

  final FirebaseAuth firebaseAuth;
  AuthSessionRepository({required this.firebaseAuth});

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get streamUser => firebaseAuth.authStateChanges();
}