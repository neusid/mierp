import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mierp_apps/domain/transaction/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {

  FirebaseFirestore firestore;

  TransactionRepositoryImpl({required this.firestore});

  @override
  Future<void> payProductOrderInvoice(docId,prodId,totalQty,date) async {
    try {
      await firestore.runTransaction(
            (transaction) async {
          transaction.update(firestore.collection("warehouse_orders").doc(docId),  {
            'finance_approved': true,
            'finance_approved_date': date,
          });
          transaction.update(firestore.collection("products").doc(prodId), {
            "quantity":FieldValue.increment(totalQty)
          });
        },
      );
    } catch(e) {
      print("Found Error: $e");
    }
  }

  @override
  Future<void> paySalesOrderInvoice(docId,prodId,totalQty,date) async {
    await firestore.runTransaction(
          (transaction) async {
        transaction.update(firestore.collection("sales_orders").doc(docId), {
          'finance_approved': true,
          'finance_approved_date': date,
        });
        transaction.update(firestore.collection("products").doc(prodId), {
          "quantity":FieldValue.increment(-totalQty)
        });
      },
    );
  }
}