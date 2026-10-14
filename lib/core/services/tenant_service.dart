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

  /// Ensures that a default master Admin account exists in Firebase Auth & Firestore.
  /// If it does not exist yet, it safely seeds it via an isolated secondary FirebaseApp.
  static Future<void> ensureDefaultAdminAccount() async {
    const adminEmail = 'admin@mierp.com';
    const adminPassword = 'password123';
    const companyName = 'PT MiERP Indonesia';

    FirebaseApp? tempApp;
    try {
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: adminEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final doc = userQuery.docs.first;
        final data = doc.data();
        if (data['role'] != 'admin' || (data['admin_id'] == null || data['admin_id'].toString().isEmpty)) {
          await doc.reference.update({
            'role': 'admin',
            'admin_id': doc.id,
            'company_name': companyName,
            'is_active': true,
          });
        }
        return;
      }

      // Safe creation using isolated secondary FirebaseApp instance
      final appName = 'DefaultAdminProvisioner_${DateTime.now().millisecondsSinceEpoch}';
      tempApp = await Firebase.initializeApp(
        name: appName,
        options: Firebase.app().options,
      );

      final tempAuth = FirebaseAuth.instanceFor(app: tempApp);
      UserCredential? cred;
      try {
        cred = await tempAuth.createUserWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          cred = await tempAuth.signInWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );
        } else {
          debugPrint("Notice: Failed to create default admin auth: $e");
        }
      }

      if (cred?.user != null) {
        final uid = cred!.user!.uid;
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'email': adminEmail,
          'first_name': 'Super',
          'last_name': 'Admin',
          'role': 'admin',
          'admin_id': uid,
          'company_name': companyName,
          'is_active': true,
          'allow_google_login': false,
          'created_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint("TenantService: Successfully verified/seeded default Admin: $adminEmail");
      }
    } catch (e) {
      debugPrint("Notice: ensureDefaultAdminAccount error: $e");
    } finally {
      if (tempApp != null) {
        try {
          await tempApp.delete();
        } catch (_) {}
      }
    }
  }
}
