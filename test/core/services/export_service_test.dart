import 'package:flutter_test/flutter_test.dart';
import 'package:mierp_apps/core/models/all_summary.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/services/export_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExportService Tests', () {
    final sampleProducts = [
      Product(
        id: 'P01',
        productCode: 'PRD-001',
        productName: 'Mechanical Keyboard RGB',
        category: 'Electronics',
        quantity: 15,
        unitPrice: 120,
        createdOn: '2026-10-10',
        imageProduct: '',
      ),
      Product(
        id: 'P02',
        productCode: 'PRD-002',
        productName: 'Ergonomic Desk Chair',
        category: 'Furniture',
        quantity: 4,
        unitPrice: 250,
        createdOn: '2026-10-11',
        imageProduct: '',
      ),
    ];

    final sampleOrders = [
      OrderProduct(
        id: 'ORD-101',
        productId: 'P01',
        productCode: 'PRD-001',
        productName: 'Warehouse Pallet Heavy Duty',
        firstName: 'John Warehouse',
        userId: 'U01',
        imageProduct: '',
        quantity: 50,
        totalCost: 1500,
        unitPrice: 30,
        financeApproved: true,
        financeApprovedDate: DateTime.now(),
        orderDate: '2026-10-12',
      ),
      OrderProduct(
        id: 'ORD-102',
        productId: 'P02',
        productCode: 'PRD-002',
        productName: 'Barcode Scanner Wireless',
        firstName: 'Jane Staff',
        userId: 'U02',
        imageProduct: '',
        quantity: 10,
        totalCost: 800,
        unitPrice: 80,
        financeApproved: false,
        financeApprovedDate: null,
        orderDate: '2026-10-13',
      ),
    ];

    final sampleSalesOrders = [
      SalesOrder(
        id: 'SLS-501',
        productId: 'P01',
        productCode: 'PRD-001',
        productName: 'Mechanical Keyboard RGB',
        companyName: 'Tech Indo Corp',
        firstName: 'Client Corp',
        userId: 'U03',
        imageProduct: '',
        quantity: 10,
        totalPrice: 1200,
        unitPrice: 120,
        financeApproved: true,
        financeApprovedDate: '2026-10-12',
        paymentStatus: true,
        purchasedDate: '2026-10-12',
      ),
    ];

    final sampleSummaries = [
      AllSummary(
        summaryType: SummaryType.salesOrder,
        data: sampleSalesOrders.first,
        createdOn: '2026-10-12',
      ),
      AllSummary(
        summaryType: SummaryType.product,
        data: sampleProducts.first,
        createdOn: '2026-10-10',
      ),
    ];

    test('ExportResult model holds correct properties', () {
      const res = ExportResult(
        success: true,
        filePath: '/tmp/test.pdf',
        fileName: 'test.pdf',
      );
      expect(res.success, isTrue);
      expect(res.filePath, equals('/tmp/test.pdf'));
      expect(res.fileName, equals('test.pdf'));
      expect(res.errorMessage, isNull);
    });

    test('ExportFormat enum defines pdf and csv', () {
      expect(ExportFormat.values.contains(ExportFormat.pdf), isTrue);
      expect(ExportFormat.values.contains(ExportFormat.csv), isTrue);
    });

    test('Product export data validation', () {
      expect(sampleProducts.length, 2);
      final totalQty = sampleProducts.fold<int>(0, (sum, p) => sum + p.quantity);
      expect(totalQty, 19);
      final totalValuation = sampleProducts.fold<int>(0, (sum, p) => sum + (p.quantity * p.unitPrice));
      expect(totalValuation, (15 * 120) + (4 * 250));
    });

    test('Warehouse Order approval counts logic', () {
      final approved = sampleOrders.where((o) => o.financeApproved == true).length;
      final pending = sampleOrders.where((o) => o.financeApproved != true && o.isRejected != true).length;
      expect(approved, 1);
      expect(pending, 1);
    });

    test('Sales Order revenue calculation logic', () {
      final totalRevenue = sampleSalesOrders.fold<int>(0, (sum, s) => sum + s.totalPrice);
      expect(totalRevenue, 1200);
    });

    test('AllSummary items count verification', () {
      expect(sampleSummaries.length, 2);
    });
  });
}
