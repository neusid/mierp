import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';

class SummaryRepository {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Future<List<Product>> searchProducts(collection,searchKey) async {
  //   try {
  //
  //     final snapshot  = await firestore.collection(collection)
  //         .where('product_name', isGreaterThanOrEqualTo: searchKey)
  //         .where('product_name', isLessThan: '${searchKey}z')
  //         .get();
  //
  //     final result = snapshot
  //         .docs.map((data)=>Product.fromJson(data.data(), docId: data.id))
  //         .toList();
  //
  //     return result;
  //   } catch(e) {
  //     print(e);
  //     return [];
  //   }
  // }
  //
  // Future<List<OrderProduct>> searchOrder(collection, searchKey) async {
  //   try {
  //     final snapshot = await firestore.collection(collection)
  //         .where('product_name', isGreaterThanOrEqualTo: searchKey)
  //         .where('product_name', isLessThan: '${searchKey}z')
  //         .get();
  //
  //     final result = snapshot.docs.map((data) => OrderProduct.fromJson(data.data(), docId: data.id)).toList();
  //
  //     return result;
  //   } catch(e) {
  //     print(e);
  //     return [];
  //   }
  // }
  //
  // Future<List<SalesOrder>> searchSalesOrder(collection, searchKey) async {
  //   try {
  //     final snapshot = await firestore.collection(collection)
  //         .where('product_name', isGreaterThanOrEqualTo: searchKey)
  //         .where('product_name', isLessThan: '${searchKey}z')
  //         .get();
  //
  //     final result = snapshot.docs.map((data) => SalesOrder.fromJson(data.data(),docId: data.id)).toList();
  //
  //     return result;
  //   } catch(e) {
  //     print(e);
  //     return [];
  //   }
  // }
  //
  // Future<List<OrderProduct?>> getfilteredDataProductOrder(filter) async {
  //   try {
  //     final snapshot = await firestore.collection('warehouse_orders').where('finance_approved', isEqualTo: filter).get();
  //     return snapshot.docs.map((e) => OrderProduct.fromJson(e.data(), docId: e.id),).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return [];
  // }
  //
  // Future<List<SalesOrder?>> getfilteredDataSalesOrder(filter) async {
  //   try {
  //     final snapshot = await firestore.collection('sales_orders').where('finance_approved', isEqualTo: filter).get();
  //     return snapshot.docs.map((e) => SalesOrder.fromJson(e.data(), docId: e.id),).toList();
  //   } catch (e) {
  //     print(e);
  //   }
  //   return [];
  // }


}