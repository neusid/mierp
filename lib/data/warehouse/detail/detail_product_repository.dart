import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mierp_apps/core/models/product.dart';

class DetailProductRepository {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Product> getSingleProduct(docId) async {
    try {
      final snapshot = await firestore.collection("products").doc(docId).get();
      Product product = Product.fromJson(snapshot.data()!, docId: docId);
      return product;
    } catch(e) {
      rethrow;
    }
  }

  Future<void> updateSingleProduct(Product product) async {
    try {
      await firestore.collection("products").doc(product.id!).update(
        ({
          "category": product.category!,
          "created_on": product.createdOn!,
          "image_product": '',
          "product_code": product.productCode!,
          "product_name": product.productName!,
          "quantity": product.quantity,
          "unit_price": product.unitPrice
        }),
      );
    } catch(e) {
      rethrow;
    }
  }
}