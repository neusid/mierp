import 'package:flutter_test/flutter_test.dart';
import 'package:mierp_apps/core/models/product.dart';

void main() {
  group('Product.fromJson Defensive Parsing Tests', () {
    test('Correctly parses valid product JSON with integer numbers', () {
      final json = {
        'category': 'Electronics',
        'created_on': '2026-10-14 10:00:00',
        'image_product': 'https://example.com/img.png',
        'product_name': 'Mechanical Keyboard',
        'product_code': 'KB-01',
        'quantity': 25,
        'unit_price': 150000,
        'discount_percent': 10,
        'discount_max': 20000,
      };

      final product = Product.fromJson(json, docId: 'doc_123');

      expect(product.id, 'doc_123');
      expect(product.category, 'Electronics');
      expect(product.productName, 'Mechanical Keyboard');
      expect(product.productCode, 'KB-01');
      expect(product.quantity, 25);
      expect(product.unitPrice, 150000);
      expect(product.discountPercent, 10);
      expect(product.discountMax, 20000);
    });

    test('Defensively parses String numbers and null fields without throwing TypeError', () {
      final json = {
        'category': null,
        'created_on': null,
        'image_product': null,
        'product_name': null,
        'product_code': null,
        'quantity': '15', // string number
        'unit_price': '250000', // string number
        'discount_percent': '5',
        'discount_max': '10000',
      };

      final product = Product.fromJson(json, docId: 'doc_456');

      expect(product.id, 'doc_456');
      expect(product.category, 'general');
      expect(product.productName, '');
      expect(product.productCode, '');
      expect(product.quantity, 15);
      expect(product.unitPrice, 250000);
      expect(product.discountPercent, 5);
      expect(product.discountMax, 10000);
    });

    test('Defensively parses double numbers without throwing TypeError', () {
      final json = {
        'category': 'Stationery',
        'created_on': '2026-10-14',
        'product_name': 'Pen',
        'product_code': 'P-01',
        'quantity': 10.0, // double
        'unit_price': 5000.0, // double
      };

      final product = Product.fromJson(json, docId: 'doc_789');

      expect(product.quantity, 10);
      expect(product.unitPrice, 5000);
    });

    test('Defensively handles empty map and fallback defaults', () {
      final json = <String, dynamic>{};

      final product = Product.fromJson(json, docId: 'empty_doc');

      expect(product.id, 'empty_doc');
      expect(product.category, 'general');
      expect(product.productName, '');
      expect(product.quantity, 0);
      expect(product.unitPrice, 0);
      expect(product.discountPercent, isNull);
      expect(product.discountMax, isNull);
    });
  });
}
