import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/data/warehouse/add/add_sales_order_repository.dart';
import 'package:mierp_apps/data/warehouse/warehouse_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSalesOrderViewModel extends GetxController {
  final warehouseR = WarehouseRepository();
  final loadingC = Get.find<LoadingController>();
  final addSalesOrderR = AddSalesOrderRepository();
  final movPage = Get.find<MovePageController>();

  RxList<Product?> listProduct = <Product?>[].obs;
  Rxn<Product> selectedProduct = Rxn<Product>();

  final financeApproved = TextEditingController();
  final financeApprovedDate = TextEditingController();
  final orderDateC = TextEditingController();
  String? productCodeC = "";
  String? productIdC = "";
  String? nameProductC = "";
  final quantityC = TextEditingController();
  String? totalCostC = "";
  final companyNameC = TextEditingController();
  final purchasedDateC = TextEditingController();
  String? unitPrice = "";
  String? imageProduct;

  @override
  void onInit() {
    // TODO: implement onInit
    loadAllProduct();
    super.onInit();
  }

  void loadAllProduct() async {
    listProduct.value = await warehouseR.getBulkDataStock("products");
  }

  Future<void> showDate(context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      ),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        ),
      );
      if (pickedTime != null) {
        final dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        final formatDateTime = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(dateTime);
        purchasedDateC.text = formatDateTime;
      }
    }
  }

  Future<void> addSalesOrder() async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      final dataRawUser = await preferences.getString('user');
      Map<String, dynamic> dataUser = jsonDecode(dataRawUser!);

      loadingC.showLoading();
      if (selectedProduct.value != null) {
        getDataRaw();
      }

      SalesOrder salesOrder = SalesOrder(
        id: "",
        companyName: companyNameC.text,
        financeApproved: false,
        financeApprovedDate: financeApprovedDate.text,
        firstName: dataUser['first_name'],
        paymentStatus: false,
        productCode: productCodeC!,
        productId: productIdC!,
        productName: nameProductC!,
        purchasedDate: purchasedDateC.text,
        quantity: int.parse(quantityC.text),
        totalPrice: int.parse(totalCostC!),
        unitPrice: int.parse(unitPrice!),
        userId: dataUser['uid'],
        imageProduct: selectedProduct.value!.imageProduct!,
      );

      await addSalesOrderR.addSalesOrderToFireStore(salesOrder);

      Get.snackbar("Success", "Success add sales order!");
      Future.delayed(Duration(seconds: 2), () {
        loadingC.hideLoading();
        Get.offAndToNamed("warehouse_main_page");
      });
    } catch (e) {
      loadingC.hideLoading();
      Get.snackbar("Failed", "$e");
    }
  }

  void getDataRaw() {
    final totalCost =
        selectedProduct.value!.unitPrice * int.parse(quantityC.text);

    productIdC = selectedProduct.value!.id;
    productCodeC = selectedProduct.value!.productCode;
    nameProductC = selectedProduct.value!.productName;
    totalCostC = totalCost.toString();
    unitPrice = selectedProduct.value!.unitPrice.toString();
    imageProduct = selectedProduct.value!.imageProduct;
  }

  void resetControllerInput() {
    companyNameC.clear();
    financeApproved.clear();
    financeApprovedDate.clear();
    orderDateC.clear();
    quantityC.clear();
    purchasedDateC.clear();
    selectedProduct.value = null;
  }
}
