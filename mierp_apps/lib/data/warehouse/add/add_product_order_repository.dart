import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mierp_apps/core/models/order.dart';

class AddProductOrderRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addProductOrderToFireStore(OrderProduct order) async {
    try {
      await firestore.collection("warehouse_orders").add({
        "finance_approved": order.financeApproved,
        "finance_approved_date": order.financeApprovedDate,
        "first_name": order.firstName,
        "order_date": order.orderDate,
        "product_code": order.productCode,
        "product_id": order.productId,
        "product_name": order.productName,
        "quantity": order.quantity,
        "total_cost": order.totalCost,
        "unit_price": order.unitPrice,
        "user_id": order.userId,
        "image_product": order.imageProduct,
      });
    } catch (e) {
      rethrow;
    }
  }
}
