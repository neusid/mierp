import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/state/item_store.dart';

class ItemStoreRepositoryImpl implements ItemRepository {

  final FirebaseFirestore firestore;
  final ItemStore itemStore;

  ItemStoreRepositoryImpl(this.firestore,this.itemStore);

  @override
  Future<void> getBulkDataStock() async {
     final snapshot = await firestore.collection("products").get();

     final data = snapshot.docs.map(
              (doc)=>Product.fromJson(doc.data(), docId: doc.id)
      ).toList();

     itemStore.setProductsList(data);
  }

  @override
  Future<void> getBulkDataOrder() async {
    try {
      final snapshot = await firestore.collection("warehouse_orders").get();

      final data = snapshot.docs.map(
              (doc){
            return OrderProduct.fromJson(doc.data(), docId: doc.id);
          }
      ).toList();

      itemStore.setOrderProductList(data);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  Future<void> getBulkDataSalesOrder() async {
    final snapshot = await firestore.collection("sales_orders").get();

    final data = snapshot.docs.map(
            (doc){
          print("ini ${doc.data()}");
          return SalesOrder.fromJson(doc.data(), docId: doc.id);
        }
    ).toList();

    itemStore.setSalesOrderList(data);
  }

  @override
  Future<Product> getDetailDataStock(String docId) async {
    Product? cached;
    try {
      cached = itemStore.listProduct.firstWhere(
        (e) => e != null && e.id == docId,
        orElse: () => null,
      );
    } catch (_) {}

    try {
      final snapshot = await firestore
          .collection("products")
          .doc(docId)
          .get()
          .timeout(const Duration(seconds: 4));

      if (snapshot.exists && snapshot.data() != null) {
        final data = Product.fromJson(
          snapshot.data() as Map<String, dynamic>,
          docId: docId,
        );
        itemStore.setProducts(data);
        return data;
      }
    } catch (e) {
      if (cached != null) {
        itemStore.setProducts(cached);
        return cached;
      }
      rethrow;
    }

    if (cached != null) {
      itemStore.setProducts(cached);
      return cached;
    }

    throw Exception("Data produk tidak ditemukan ($docId)");
  }

  @override
  Future<OrderProduct> getDetailDataOrder(String docId) async {
    OrderProduct? cached;
    try {
      cached = itemStore.listOrder.firstWhere(
        (e) => e != null && e.id == docId,
        orElse: () => null,
      );
    } catch (_) {}

    try {
      final snapshot = await firestore
          .collection("warehouse_orders")
          .doc(docId)
          .get()
          .timeout(const Duration(seconds: 4));

      if (snapshot.exists && snapshot.data() != null) {
        final data = OrderProduct.fromJson(
          snapshot.data() as Map<String, dynamic>,
          docId: docId,
        );
        itemStore.setOrderProduct(data);
        return data;
      }
    } catch (e) {
      if (cached != null) {
        itemStore.setOrderProduct(cached);
        return cached;
      }
      rethrow;
    }

    if (cached != null) {
      itemStore.setOrderProduct(cached);
      return cached;
    }

    throw Exception("Data order tidak ditemukan ($docId)");
  }

  @override
  Future<SalesOrder> getDetailDataSalesOrder(String prodId) async {
    SalesOrder? cached;
    try {
      cached = itemStore.listSalesOrder.firstWhere(
        (e) => e != null && e.id == prodId,
        orElse: () => null,
      );
    } catch (_) {}

    try {
      final snapshot = await firestore
          .collection("sales_orders")
          .doc(prodId)
          .get()
          .timeout(const Duration(seconds: 4));

      if (snapshot.exists && snapshot.data() != null) {
        final data = SalesOrder.fromJson(
          snapshot.data() as Map<String, dynamic>,
          docId: prodId,
        );
        itemStore.setSalesOrder(data);
        return data;
      }
    } catch (e) {
      if (cached != null) {
        itemStore.setSalesOrder(cached);
        return cached;
      }
      rethrow;
    }

    if (cached != null) {
      itemStore.setSalesOrder(cached);
      return cached;
    }

    throw Exception("Data sales order tidak ditemukan ($prodId)");
  }

  @override
  Future<void> updateDetailDataStock(prodId, Product product) async {
    await firestore.collection("products").doc(prodId).update(
      {
        "category": product.category,
        "created_on": product.createdOn,
        "image_product": '',
        "product_code": product.productCode,
        "product_name": product.productName,
        "quantity": product.quantity,
        "unit_price": product.unitPrice
      }
    );
  }

  @override
  Future<void> deleteDetailDataStock(prodId) async {
    await firestore.collection("products").doc(prodId).delete();
  }
}