import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/data/login/exception/auth_failures.dart';
import 'package:mierp_apps/features/login/presentation/login_view_model.dart';

class LoginRepository {
  final FirebaseAuth authFirebase = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore authStore = FirebaseFirestore.instance;

  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await authFirebase.signInWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      DocumentSnapshot snapDoc = await authStore.collection('users').doc(uid).get();

      if (!snapDoc.exists) {
        return null;
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
      return userModel;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw AuthFailures.userNotFound;
        case 'wrong-password':
          throw AuthFailures.wrongPassword;
        case 'invalid-email':
          throw AuthFailures.invalidEmail;
        default:
          throw AuthFailures.unknown;
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<UserModel?> loginWithGoogle() async {
    try {

      await googleSignIn.initialize();

      final googleUser = await googleSignIn.authenticate(
        scopeHint: ['email']
      );

      final email = googleUser.email;

      final query = await authStore.collection("users").where(
        'email', isEqualTo: email
      ).limit(1).get();

      if(query.docs.isEmpty){
         throw AuthFailures.googleCanceled;
      }

      final checkProvider = query.docs.first.data();

      if (checkProvider['allow_google_login'] == false) {
        throw AuthFailures.userNotRegistrated;
      }

      final googleAutorization = await googleUser.authentication;
      final idToken = googleAutorization.idToken;

      if(idToken==null) {
        throw AuthFailures.idTokenMissing;
      };

      final googleCredential = GoogleAuthProvider.credential(
        idToken: idToken
      );
      final userCredential = await authFirebase.signInWithCredential(googleCredential);
      final uid = userCredential.user!.uid;
      final snapDoc = await authStore.collection('users').doc(uid).get();

      if(!snapDoc.exists) {
        throw AuthFailures.userNotFoundInFirestore;
      };

      final docJson = snapDoc.data() as Map<String, dynamic>;
      return UserModel.fromJson(docJson);
    } catch(e) {
      rethrow;
    }
  }

  Future<void> linkToAnotherAccount(uid) async {
    try {

      await googleSignIn.initialize();

      final googleUser = await googleSignIn.authenticate();

      if(googleUser.id.isEmpty){
        print("authenticate-failed");
        return;
      }

      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if(idToken==null){
        print("idtoken-missing");
        return;
      };

      final googleCredential = GoogleAuthProvider.credential(
        idToken: idToken
      );

      await authFirebase.currentUser!.linkWithCredential(googleCredential);

      await authStore.collection('users')
          .doc(uid)
          .update({
        'allow_google_login':true
      });


    } catch(e) {
      print("error-link-google");
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = await authFirebase.currentUser;

      if (user == null) return;

      final snapshot = await authStore.collection('users').doc(user.uid).get();
      final dataUser = await UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      final batch = FirebaseFirestore.instance.batch();

      if (dataUser.role == "warehouse") {
        
        batch.delete(authStore.collection('users').doc(user.uid));

        final salesOrdersSnapshot = await authStore.collection('sales_orders')
            .where('user_id', isEqualTo: user.uid)
            .get();

        final warehouseOrdersSnapshot = await authStore.collection('warehouse_orders')
            .where('user_id', isEqualTo: user.uid)
            .get();

        for(final doc in salesOrdersSnapshot.docs) {
          batch.delete(doc.reference);
        }

        for(final doc in warehouseOrdersSnapshot.docs) {
          batch.delete(doc.reference);
        }

      } else if(dataUser.role == 'finance') {
        await authStore.collection('users')
            .doc(user.uid)
            .delete();
      }

      await batch.commit();
      await user.delete();
    } catch (e) {
      rethrow;
    }
  }

}