import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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
}
