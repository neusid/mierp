import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:mierp_apps/core/models/user_model.dart';

abstract class AdminStaffRepository {
  Future<List<UserModel>> getStaffList(String adminId);
  Future<UserModel> createStaffAccount({
    required String adminId,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    String? companyName,
  });
  Future<void> toggleStaffStatus(String staffUid, bool isActive);
  Future<void> deleteStaff(String staffUid);
}

class AdminStaffRepositoryImpl implements AdminStaffRepository {
  final FirebaseFirestore firestore;

  AdminStaffRepositoryImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<UserModel>> getStaffList(String adminId) async {
    try {
      final snap = await firestore
          .collection('users')
          .where('admin_id', isEqualTo: adminId)
          .get();

      final list = snap.docs
          .map((doc) {
            final data = doc.data();
            data['uid'] = doc.id;
            return UserModel.fromJson(data);
          })
          .where((u) => u.role != 'admin')
          .toList();

      return list;
    } catch (e) {
      debugPrint("Error fetching staff list: $e");
      rethrow;
    }
  }

  @override
  Future<UserModel> createStaffAccount({
    required String adminId,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    String? companyName,
  }) async {
    FirebaseApp? tempApp;
    try {
      // 1. Initialize an isolated secondary FirebaseApp so current Admin session is not lost
      final appName = 'StaffCreate_${DateTime.now().millisecondsSinceEpoch}';
      tempApp = await Firebase.initializeApp(
        name: appName,
        options: Firebase.app().options,
      );

      final tempAuth = FirebaseAuth.instanceFor(app: tempApp);
      final cred = await tempAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final staffUid = cred.user!.uid;

      // 2. Write staff record to primary Firestore with admin_id scoping
      final staffModel = UserModel(
        uid: staffUid,
        email: email.trim(),
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        role: role.trim().toLowerCase(),
        adminId: adminId,
        companyName: companyName,
        allowGoogleLogin: false,
      );

      await firestore.collection('users').doc(staffUid).set({
        ...staffModel.toJson(),
        'created_at': FieldValue.serverTimestamp(),
        'is_active': true,
      });

      return staffModel;
    } catch (e) {
      debugPrint("Error creating staff account: $e");
      rethrow;
    } finally {
      // Clean up the temporary secondary app
      if (tempApp != null) {
        try {
          await tempApp.delete();
        } catch (_) {}
      }
    }
  }

  @override
  Future<void> toggleStaffStatus(String staffUid, bool isActive) async {
    try {
      await firestore.collection('users').doc(staffUid).update({
        'is_active': isActive,
      });
    } catch (e) {
      debugPrint("Error toggling staff status: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteStaff(String staffUid) async {
    try {
      await firestore.collection('users').doc(staffUid).delete();
    } catch (e) {
      debugPrint("Error deleting staff doc: $e");
      rethrow;
    }
  }
}
