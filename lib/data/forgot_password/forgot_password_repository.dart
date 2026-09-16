
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordRepository {

  FirebaseAuth firebaseAuth;
  ForgotPasswordRepository(this.firebaseAuth);

  Future<void> sendPasswordResetVerification(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch(e) {
      rethrow;
    }
  }
}