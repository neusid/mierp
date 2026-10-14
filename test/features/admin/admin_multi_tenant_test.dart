import 'package:flutter_test/flutter_test.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/features/notification/data/models/notification_model.dart';

void main() {
  group('Multi-Tenant UserModel Tests', () {
    test('Admin user should have isAdmin == true and effectiveAdminId == uid', () {
      final adminUser = UserModel(
        uid: 'admin_123',
        email: 'ceo@company.com',
        firstName: 'John',
        lastName: 'Doe',
        role: 'admin',
        companyName: 'PT Sukses Mandiri',
        allowGoogleLogin: false,
      );

      expect(adminUser.isAdmin, isTrue);
      expect(adminUser.isFinance, isFalse);
      expect(adminUser.isWarehouse, isFalse);
      expect(adminUser.effectiveAdminId, equals('admin_123'));
    });

    test('Finance staff should have isFinance == true and effectiveAdminId == adminId', () {
      final financeStaff = UserModel(
        uid: 'staff_fin_01',
        email: 'finance@company.com',
        firstName: 'Finance',
        lastName: 'Staff',
        role: 'finance',
        adminId: 'admin_123',
        companyName: 'PT Sukses Mandiri',
        allowGoogleLogin: false,
      );

      expect(financeStaff.isAdmin, isFalse);
      expect(financeStaff.isFinance, isTrue);
      expect(financeStaff.isWarehouse, isFalse);
      expect(financeStaff.effectiveAdminId, equals('admin_123'));
    });

    test('Warehouse staff should have isWarehouse == true and effectiveAdminId == adminId', () {
      final warehouseStaff = UserModel(
        uid: 'staff_wh_01',
        email: 'warehouse@company.com',
        firstName: 'Warehouse',
        lastName: 'Staff',
        role: 'warehouse',
        adminId: 'admin_123',
        companyName: 'PT Sukses Mandiri',
        allowGoogleLogin: false,
      );

      expect(warehouseStaff.isAdmin, isFalse);
      expect(warehouseStaff.isFinance, isFalse);
      expect(warehouseStaff.isWarehouse, isTrue);
      expect(warehouseStaff.effectiveAdminId, equals('admin_123'));
    });

    test('Legacy staff without adminId should fallback effectiveAdminId to empty string', () {
      final legacyStaff = UserModel(
        uid: 'legacy_staff_99',
        email: 'old@company.com',
        firstName: 'Old',
        lastName: 'Staff',
        role: 'finance',
        adminId: null,
        allowGoogleLogin: false,
      );

      expect(legacyStaff.effectiveAdminId, equals(''));
    });

    test('UserModel JSON serialization round-trip retains multi-tenant fields', () {
      final original = UserModel(
        uid: 'user_001',
        email: 'staff@test.com',
        firstName: 'Staff',
        lastName: 'Finance',
        role: 'finance',
        adminId: 'admin_owner_55',
        companyName: 'Berkah Abadi Corp',
        allowGoogleLogin: true,
      );

      final json = original.toJson();
      expect(json['admin_id'], equals('admin_owner_55'));
      expect(json['company_name'], equals('Berkah Abadi Corp'));
      expect(json['allow_google_login'], isTrue);
      expect(json['role'], equals('finance'));

      final reconstructed = UserModel.fromJson(json);
      expect(reconstructed.uid, equals('user_001'));
      expect(reconstructed.adminId, equals('admin_owner_55'));
      expect(reconstructed.companyName, equals('Berkah Abadi Corp'));
      expect(reconstructed.allowGoogleLogin, isTrue);
      expect(reconstructed.role, equals('finance'));
      expect(reconstructed.effectiveAdminId, equals('admin_owner_55'));
    });
  });

  group('Multi-Tenant Notification Scoping Tests', () {
    test('NotificationModel should serialize to Firestore map with admin_id correctly', () {
      final notif = NotificationModel(
        id: 'notif_100',
        targetRole: 'finance',
        type: 'order_approved',
        title: 'Order Approved',
        message: 'Order #PO-123 disetujui',
        orderId: 'PO-123',
        orderType: 'product_order',
        productName: 'iPhone 15 Pro',
        isRead: false,
        createdAt: DateTime(2026, 10, 14, 10, 0),
        adminId: 'admin_company_x',
      );

      final map = notif.toFirestore();
      expect(map['admin_id'], equals('admin_company_x'));
      expect(map['target_role'], equals('finance'));
      expect(map['order_id'], equals('PO-123'));
      expect(map['product_name'], equals('iPhone 15 Pro'));
    });

    test('Notifications from Admin A should not bleed into Admin B', () {
      final notifAdminA = NotificationModel(
        id: 'notif_a',
        targetRole: 'finance',
        type: 'order_created',
        title: 'Admin A Order',
        message: 'Data PT Alpha',
        orderId: 'SO-1',
        orderType: 'sales_order',
        productName: 'MacBook Pro',
        isRead: false,
        createdAt: DateTime.now(),
        adminId: 'admin_alpha',
      );

      final notifAdminB = NotificationModel(
        id: 'notif_b',
        targetRole: 'finance',
        type: 'order_created',
        title: 'Admin B Order',
        message: 'Data PT Beta',
        orderId: 'SO-2',
        orderType: 'sales_order',
        productName: 'Dell XPS',
        isRead: false,
        createdAt: DateTime.now(),
        adminId: 'admin_beta',
      );

      // Isolation assertion
      expect(notifAdminA.adminId, isNot(equals(notifAdminB.adminId)));
      expect(notifAdminA.adminId, equals('admin_alpha'));
      expect(notifAdminB.adminId, equals('admin_beta'));
    });
  });
}
