import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mierp_apps/core/models/sales_order.dart';

class AddSalesOrderRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addSalesOrderToFireStore(SalesOrder salesOrder) async {
    try {
      await firestore.collection("sales_orders").add({
        "company_name": salesOrder.companyName,
        "finance_approved": salesOrder.financeApproved,
        "finance_approved_date": salesOrder.financeApprovedDate,
        "first_name": salesOrder.firstName,
        "payment_status": salesOrder.paymentStatus,
        "product_code": salesOrder.productCode,
        "product_id": salesOrder.productId,
        "product_name": salesOrder.productName,
        "purchased_date": salesOrder.purchasedDate,
        "quantity": salesOrder.quantity,
        "total_price": salesOrder.totalPrice,
        "unit_price": salesOrder.unitPrice,
        "user_id": salesOrder.userId,
        "image_product": salesOrder.imageProduct,
      });
    } catch (e) {
      rethrow;
    }
  }
}
