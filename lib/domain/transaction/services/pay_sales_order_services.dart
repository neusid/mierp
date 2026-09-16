import 'package:intl/intl.dart';
import 'package:mierp_apps/data/warehouse/detail/detail_sales_order_repository.dart';

class PaySalesOrderServices {
  DetailSalesOrderRepository detailSalesOrderRepository;
  PaySalesOrderServices(this.detailSalesOrderRepository);

  Future<void> payInvoice(docId, prodId, totalQty) async {
    try {
      final product = await  detailSalesOrderRepository.getProduct(prodId);
      if (totalQty >= product.quantity) {
        throw("Out of stock");
      }
      final now = DateTime.now();
      final dateParse = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      await detailSalesOrderRepository.payInvoiceOrder(docId, prodId, dateParse, totalQty);
    } catch(e) {
      rethrow;
    }
  }
}