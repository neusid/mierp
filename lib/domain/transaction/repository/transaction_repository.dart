
abstract class TransactionRepository {

  Future<void> payProductOrderInvoice(docId, prodId, totalQty, date);
  Future<void> paySalesOrderInvoice(docId, prodId, totalQty, date);
  Future<void> rejectProductOrderInvoice(String docId, String reason, String date);
  Future<void> rejectSalesOrderInvoice(String docId, String reason, String date);
}