import 'package:get/get.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/data/transaction/services/transaction_services.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/domain/transaction/services/pay_sales_order_services.dart';
import 'package:mierp_apps/data/warehouse/detail/detail_sales_order_repository.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/state/item_store.dart';

class DetailSalesOrderViewModel extends GetxController {

  final id;
  final ItemRepository itemRepository;
  final ItemStore itemStore;
  final TransactionServices transactionServices;

  DetailSalesOrderViewModel({required this.id, required this.itemRepository, required this.itemStore, required this.transactionServices});

  final totalCost = "".obs;
  final unitPrice = "".obs;

  final detailSalesOrderR = DetailSalesOrderRepository();
  final loadingC = Get.find<LoadingController>();
  final movePageC = Get.find<MovePageController>();
  // final paySalesOrderService = Get.find<PaySalesOrderServices>();
  final convertDollar = ConvertDollar();
  final userDataC = UserDataController();

  RxBool success = false.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;
  Rxn role = Rxn();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getSalesOrder(id);
    getRoleUser();
  }

  Rxn<SalesOrder> get salesOrder {
    return itemStore.salesOrders;
  }

  Future<void> getRoleUser() async {
    UserModel user = await userDataC.getDataUser();
    role.value = user.role;
  }

  void resetVariable() {
    itemStore.clearDetailProduct();
  }

  Future<void> requestPaySalesOrder(docId, prodId, totalQty) async {
    try {
      isLoading.value = true;

      await transactionServices.paySalesOrderServices(docId, prodId, totalQty);
      await itemRepository.getDetailDataSalesOrder(docId);
      await itemRepository.getBulkDataSalesOrder();

      isLoading.value = false;
      success.value = true;
    } catch(e) {
      isLoading.value = false;
      errorMessage.value = "$e";
    }
  }

  Future<void> getSalesOrder(id) async {
    try {
      itemRepository.getDetailDataSalesOrder(id);
    } catch(e) {
      isLoading.value = false;
      Get.back();
    }
  }

  Future<void> requestDeleteSalesOrder(docId) async {
    try {
      isLoading.value = true;
      await detailSalesOrderR.deleteSingleSalesOrder(docId);
      await itemRepository.getBulkDataSalesOrder();
      Get.snackbar("Success", "Delete success");
      Future.delayed(Duration(seconds: 2), () {
        isLoading.value = false;
        Get.toNamed("warehouse_main_page");
      },);
    } catch(e) {
      Get.snackbar("Failed", "$e");
    }
  }
}