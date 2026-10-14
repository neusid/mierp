import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Central Multi-Tenant Service for MiERP.
/// Handles resolution of the active `admin_id` (tenant key)
/// and automatic migration of legacy un-scoped Firestore records.
class TenantService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retrieves the current user's effective admin ID (tenant key) from SharedPreferences.
  static Future<String> getActiveAdminId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString("user");
      if (raw != null) {
        final user = UserModel.fromJson(jsonDecode(raw));
        return user.effectiveAdminId;
      }
    } catch (e) {
      debugPrint("Error resolving active admin ID: $e");
    }
    return '';
  }

  /// Automatically attaches legacy records without an `admin_id` to the specified [adminId].
  /// This fulfills the approved backward compatibility requirement.
  static Future<void> migrateLegacyDataToAdmin(String adminId) async {
    if (adminId.isEmpty) return;

    final collections = [
      'products',
      'sales_orders',
      'warehouse_orders',
      'financial_mutations',
      'notifications',
      'units',
    ];

    for (final col in collections) {
      try {
        final snap = await _firestore.collection(col).get();
        final batch = _firestore.batch();
        int unassignedCount = 0;

        for (final doc in snap.docs) {
          final data = doc.data();
          final existingAdminId = data['admin_id']?.toString() ?? '';
          if (existingAdminId.isEmpty) {
            batch.update(doc.reference, {'admin_id': adminId});
            unassignedCount++;
          }
        }

        if (unassignedCount > 0) {
          await batch.commit();
          debugPrint("TenantService: Migrated $unassignedCount legacy docs in '$col' to admin '$adminId'");
        }
      } catch (e) {
        debugPrint("TenantService: Migration check for '$col' skipped: $e");
      }
    }
  }

  /// Ensures that default Super Admin and Admin accounts exist in Firebase Auth & Firestore.
  /// If they do not exist yet, they are safely seeded via an isolated secondary FirebaseApp.
  static Future<void> ensureDefaultAdminAccount() async {
    await _provisionAccount(
      email: 'superadmin@mierp.com',
      password: 'password123',
      firstName: 'Super',
      lastName: 'Admin',
      role: 'superadmin',
      companyName: 'PT MiERP Indonesia',
    );

    await _provisionAccount(
      email: 'admin@mierp.com',
      password: 'password123',
      firstName: 'Master',
      lastName: 'Admin',
      role: 'admin',
      companyName: 'PT MiERP Indonesia',
    );
  }

  static Future<void> _provisionAccount({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required String companyName,
  }) async {
    FirebaseApp? tempApp;
    try {
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final doc = userQuery.docs.first;
        final data = doc.data();
        if (data['role'] != role || (data['admin_id'] == null || data['admin_id'].toString().isEmpty)) {
          await doc.reference.update({
            'role': role,
            'admin_id': doc.id,
            'company_name': companyName,
            'is_active': true,
          });
        }
        return;
      }

      // Safe creation using isolated secondary FirebaseApp instance
      final appName = 'AdminProvisioner_${role}_${DateTime.now().millisecondsSinceEpoch}';
      tempApp = await Firebase.initializeApp(
        name: appName,
        options: Firebase.app().options,
      );

      final tempAuth = FirebaseAuth.instanceFor(app: tempApp);
      UserCredential? cred;
      try {
        cred = await tempAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          cred = await tempAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          debugPrint("Notice: Failed to create $role auth: $e");
        }
      }

      if (cred?.user != null) {
        final uid = cred!.user!.uid;
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'role': role,
          'admin_id': uid,
          'company_name': companyName,
          'is_active': true,
          'allow_google_login': false,
          'created_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint("TenantService: Successfully verified/seeded default $role: $email");
      }
    } catch (e) {
      debugPrint("Notice: _provisionAccount error for $email: $e");
    } finally {
      if (tempApp != null) {
        try {
          await tempApp.delete();
        } catch (_) {}
      }
    }
  }
}
