import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/data/transaction/services/transaction_services.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/domain/transaction/services/pay_product_order_services.dart';
import 'package:mierp_apps/data/finance/dashboard_finance_repository.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/tab_item.dart';
import 'package:mierp_apps/state/item_store.dart';

class DashboardFinanceViewModel extends GetxController {

  final DashboardFinanceRepository dashboardFinanceR;
  final ItemRepository itemRepository;
  final ItemStore itemStore;
  final TransactionServices transactionServices;

  DashboardFinanceViewModel(this.dashboardFinanceR, this.itemRepository, this.itemStore, this.transactionServices);

  final userDataC = UserDataController();
  final loadingC = Get.find<LoadingController>();

  Rx<String> userName = "".obs;
  RxBool success = false.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  RxInt number = 0.obs;

  RxList<Product?> get listProduct => itemStore.listProduct;
  RxList<OrderProduct?> get listOrder => itemStore.listOrder;
  RxList<SalesOrder?> get listSalesOrder => itemStore.listSalesOrder;
  RxString collection = "all_summary".obs;

  RxInt productsItem = 0.obs;
  RxInt settled = 0.obs;
  RxInt accountPayables = 0.obs;
  RxInt accountReceivables = 0.obs;

  RxInt productTotal = 0.obs;
  RxInt totalQty = 0.obs;
  RxInt lowStock = 0.obs;
  RxInt upComingStock = 0.obs;

  final tabs = [
    TabItem("All Summary", true.obs, "all_summary"),
    TabItem("Order", false.obs, "warehouse_orders"),
    TabItem("Sales Order", false.obs, "sales_orders"),
    TabItem("Stock", false.obs, "products")
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    getUserData();
    // requestDataProduct();

    itemRepository.getBulkDataStock();
    itemRepository.getBulkDataOrder();
    itemRepository.getBulkDataSalesOrder();

    productsItem.bindStream(dashboardFinanceR.getProductItems());
    settled.bindStream(dashboardFinanceR.getSettledItems());
    accountPayables.bindStream(dashboardFinanceR.getAccountPayables());
    accountReceivables.bindStream(dashboardFinanceR.getAccountReceivables());

    productTotal.bindStream(dashboardFinanceR.getTotalProducts());
    totalQty.bindStream(dashboardFinanceR.getTotalQty());
    lowStock.bindStream(dashboardFinanceR.getLowStock());
    upComingStock.bindStream(dashboardFinanceR.getUpcomingStock());
    super.onInit();
  }

  Future<void> getUserData() async {
    try {
      UserModel? userModel = await userDataC.getDataUser();
      userName.value = userModel!.firstName! + " " + userModel!.lastName!;
    } catch(e) {
      Get.snackbar("Failed", "$e");
    }
  }


  Future<void> requestPayProductOrder(docId, prodId, totalQty) async {
    try {
      isLoading.value = true;

      await transactionServices.payProductOrderServices(docId, prodId, totalQty);
      itemRepository.getBulkDataOrder();

      success.value = true;
      isLoading.value = false;
    } catch(e) {
      errorMessage.value = "$e";
      isLoading.value = false;
    }
  }

  void changeTab(TabItem selected) {
    for(var tab in tabs) {
      tab.isActive.value = false;
    }
    if (selected.collection == "warehouse_orders") {
      itemRepository.getBulkDataOrder();
    } else if (selected.collection == "products" || selected.collection == "all_summary") {
      itemRepository.getBulkDataStock();
    } else {
      itemRepository.getBulkDataSalesOrder();
    }
    collection.value = selected.collection;
    selected.isActive.value = true;
  }

  void moveToSummaryView() {
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1), () {
      isLoading.value = false;
      Get.toNamed("/summary");
    },);
  }
}