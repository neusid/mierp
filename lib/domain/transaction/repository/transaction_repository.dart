
abstract class TransactionRepository {

  Future<void> payProductOrderInvoice(docId,prodId,totalQty,date);
  Future<void> paySalesOrderInvoice(docId,prodId,totalQty,date);
}