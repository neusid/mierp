import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/models/all_summary.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/data/warehouse/warehouse_repository.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:intl/intl.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/tab_item.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/dashboard_warehouse_view.dart';
import 'package:mierp_apps/features/summary/presentation/summary_view.dart';
import 'package:mierp_apps/state/item_store.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';

class WarehouseViewModel extends GetxController {


  final ItemRepository itemRepository;
  final ItemStore itemStore;

  WarehouseViewModel(this.itemRepository, this.itemStore);

  final warehouseRepository = WarehouseRepository();

  final userDataC = UserDataController();

  RxInt lenghtProduct = 0.obs;
  RxInt totalQtyProduct = 0.obs;
  RxInt totalLowProduct = 0.obs;
  RxInt totalUpcomingProduct = 0.obs;

  RxBool isLoading = false.obs;

  RxList<Product?> get listProduct {
    return itemStore.listProduct;
  }
  RxList<OrderProduct?> get listOrder {
    return itemStore.listOrder;
  }
  RxList<SalesOrder?> get listSalesOrder {
    return itemStore.listSalesOrder;
  }
  RxList<AllSummary?> listAllSummaryVM = <AllSummary?>[].obs;

  RxString collection = "all_summary".obs;
  RxnString userName = RxnString();


  final tabs = [
    TabItem("All Summary", true.obs, "all_summary"),
    TabItem("Order", false.obs, "warehouse_order"),
    TabItem("Sales Order", false.obs, "sales_order"),
    TabItem("Stock", false.obs, "products")
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    lenghtProduct.bindStream(warehouseRepository.streamTotalProducts());
    totalQtyProduct.bindStream(warehouseRepository.streamGetQtyProduct());
    totalLowProduct.bindStream(warehouseRepository.streamGetLowStock());
    totalUpcomingProduct.bindStream(warehouseRepository.streamGetUpcomingStock());
    itemRepository.getBulkDataStock();
    itemRepository.getBulkDataOrder();
    itemRepository.getBulkDataSalesOrder();

    getUserData();
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

  String convertDollar(value) {
    final dollar = NumberFormat.currency(
      locale: 'en_US',
      symbol: "\$",
      decimalDigits: 0
    ).format(value);
    return dollar;
  }

  void changeTab(TabItem selected) {
    for(var tab in tabs) {
      tab.isActive.value = false;
    }
    if (selected.collection == "warehouse_order") {
      itemRepository.getBulkDataOrder();
    } else if (selected.collection == "products") {
      itemRepository.getBulkDataStock();
    } else if (selected.collection == "sales_orders") {
      itemRepository.getBulkDataSalesOrder();
    }
    collection.value = selected.collection;
    selected.isActive.value = true;
  }

  List<Widget> buildScreens() {
    return [
      DashboardWarehouseView(),
      SummaryView()
    ];
  }

  void movePage(page) {
    isLoading.value = true;
    Future.delayed(Duration(seconds: 1), () {
      isLoading.value = false;
      Get.toNamed(page);
    },);
  }

  List<PersistentBottomNavBarItem> navbarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.inactiveGray,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            "/first": (final context) => DashboardWarehouseView(),
            "/second": (final context) => SummaryView(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: "Settings",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.inactiveGray,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            "/first": (final context) => DashboardWarehouseView(),
            "/second": (final context) => SummaryView(),
          },
        ),
      ),
    ];
  }

}