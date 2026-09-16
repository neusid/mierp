import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/models/all_summary.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/models/tab_item.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/data/summary/summary_repository.dart';
import 'package:mierp_apps/data/transaction/services/transaction_services.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/state/item_store.dart';

class SummaryViewModel extends GetxController {
  final ItemRepository itemRepository;
  final ItemStore itemStore;
  final TransactionServices transactionServices;

  SummaryViewModel(
    this.itemRepository,
    this.itemStore,
    this.transactionServices,
  );

  final searchKeyC = TextEditingController();
  final keyword = "".obs;
  final userDataC = UserDataController();
  final summaryR = SummaryRepository();
  final loadingC = Get.find<LoadingController>();
  // final payInvoiceServiceOrderProduct = Get.find<PayProductOrderServices>();
  // final payInvoiceServiceSalesOrder = Get.find<PaySalesOrderServices>();

  RxInt tag = 1.obs;
  RxBool success = false.obs;
  RxBool isLoading = false.obs;
  final collection = "all_summary".obs;
  final role = "warehouse".obs;
  RxString errorMessage = "".obs;

  RxList<AllSummary?> listAllSummaryVM = <AllSummary?>[].obs;

  List<Product?> get listProduct {
    if (keyword.value.isEmpty) {
      return itemStore.listProduct;
    }
    return itemStore.listProduct
        .where(
          (p) => p!.productName.toLowerCase().contains(
            searchKeyC.text.toLowerCase(),
          ),
        )
        .toList();
  }

  List<OrderProduct?> get listOrder {
    Iterable<OrderProduct?> orderProducts = itemStore.listOrder;

    if (keyword.value.isNotEmpty) {
      orderProducts = itemStore.listOrder.where(
        (p) => p!.productName.toLowerCase().contains(
          searchKeyC.text.toLowerCase(),
        ),
      );
    }

    if (tag.value == 1) {
      orderProducts = itemStore.listOrder.where((p) => p!.financeApproved!);
    }

    if (tag.value == 2) {
      orderProducts = itemStore.listOrder.where((p) => !p!.financeApproved!);
    }

    return orderProducts.toList();
  }

  List<SalesOrder?> get listSalesOrder {
    Iterable<SalesOrder?> salesOrder = itemStore.listSalesOrder;

    if (keyword.value.isNotEmpty) {
      salesOrder = itemStore.listSalesOrder.where(
        (p) => p!.productName.toLowerCase().contains(
          searchKeyC.text.toLowerCase(),
        ),
      );
    }

    if (tag.value == 1) {
      salesOrder = itemStore.listSalesOrder.where((p) => p!.financeApproved!);
    }

    if (tag.value == 2) {
      salesOrder = itemStore.listSalesOrder.where((p) => !p!.financeApproved!);
    }

    return salesOrder.toList();
  }

  List<AllSummary?> get listAllSummary {
    Iterable<AllSummary?> allSummary = itemStore.listAllSummary;

    if (keyword.value.isNotEmpty) {
      allSummary = itemStore.listAllSummary.where(
        (p) => p!.data.productName.toLowerCase().contains(
          searchKeyC.text.toLowerCase(),
        ),
      );
    }

    return allSummary.toList();
  }

  final tabs = [
    TabItem("All Summary", true.obs, "all_summary"),
    TabItem("Order", false.obs, "warehouse_orders"),
    TabItem("Sales Order", false.obs, "sales_orders"),
    TabItem("Stock", false.obs, "products"),
  ];

  RxList<String> options = ['All', 'Paid', 'Unpaid'].obs;

  late final summaryVM;

  @override
  void onInit() {
    // TODO: implement onInit
    itemRepository.getBulkDataStock();
    itemRepository.getBulkDataOrder();
    itemRepository.getBulkDataSalesOrder();

    getUserData();
    super.onInit();
  }

  void filterData(select) async {
    tag.value = select;
  }

  Future<void> getUserData() async {
    try {
      UserModel? userModel = await userDataC.getDataUser();
      role.value = userModel!.role!;
    } catch (e) {
      Get.snackbar("Failed", "$e");
    }
  }

  void changeTab(TabItem selected) {
    for (var tab in tabs) {
      tab.isActive.value = false;
    }
    if (selected.collection == "warehouse_orders") {
      itemRepository.getBulkDataOrder();
    } else if (selected.collection == "products") {
      itemRepository.getBulkDataStock();
    } else if (selected.collection == "sales_orders") {
      itemRepository.getBulkDataSalesOrder();
    }
    tag.value = 0;
    collection.value = selected.collection;
    selected.isActive.value = true;
  }

  Future<void> detailProductOrder(id) async {
    try {
      isLoading.value = true;
      Future.delayed(Duration(seconds: 1), () {
        isLoading.value = false;
        Get.toNamed("/detail_product_order/${id}");
      });
    } catch (e) {
      loadingC.hideLoading();
      Get.snackbar("Failed", "$e");
    }
  }

  Future<void> detailSalesOrder(id) async {
    try {
      isLoading.value = true;

      Future.delayed(Duration(seconds: 1), () {
        isLoading.value = false;
        Get.toNamed("/detail_sales_order/${id}");
      });
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Failed", "$e");
    }
  }

  Future<void> requestPayInvoiceOrderProduct(docId, prodId, totalQty) async {
    try {
      isLoading.value = true;

      await transactionServices.payProductOrderServices(
        docId,
        prodId,
        totalQty,
      );
      itemRepository.getBulkDataOrder();
      isLoading.value = false;
      success.value = true;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = "Error, $e";
    }
  }

  void moveBack() {
    isLoading.value = true;
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      Get.back();
    });
  }

  void combinedDataAll() {
    final combined = <AllSummary>[];

    combined.addAll(
      listProduct.map(
        (e) => AllSummary(
          summaryType: SummaryType.product,
          data: e,
          createdOn: e!.createdOn,
        ),
      ),
    );
    combined.addAll(
      listOrder.map(
        (e) => AllSummary(
          summaryType: SummaryType.order,
          data: e,
          createdOn: e!.orderDate!,
        ),
      ),
    );
    combined.addAll(
      listSalesOrder.map(
        (e) => AllSummary(
          summaryType: SummaryType.salesOrder,
          data: e,
          createdOn: e!.purchasedDate,
        ),
      ),
    );
    combined.sort((a, b) => b.createdOn.compareTo(a.createdOn));

    listAllSummary.assignAll(combined);
  }
}
