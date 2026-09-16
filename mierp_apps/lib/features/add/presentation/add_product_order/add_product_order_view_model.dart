import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/data/warehouse/add/add_product_order_repository.dart';
import 'package:mierp_apps/data/warehouse/warehouse_repository.dart';

class AddProductOrderViewModel extends GetxController {
  final addProductOrderR = AddProductOrderRepository();
  final warehouseR = WarehouseRepository();
  final loadingC = Get.find<LoadingController>();
  final movePageC = Get.find<MovePageController>();

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
  String? unitPriceC = "";

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
        orderDateC.text = formatDateTime;
      }
    }
  }

  Future<void> addProductOrder() async {
    try {
      final userDataC = UserDataController();

      UserModel? userModel = await userDataC.getDataUser();

      getDataRaw();

      OrderProduct? orderProduct = OrderProduct(
        id: '',
        financeApproved: false,
        financeApprovedDate: null,
        orderDate: orderDateC.text,
        productId: productIdC!,
        productCode: productCodeC!,
        productName: nameProductC!,
        quantity: int.parse(quantityC.text),
        totalCost: int.parse(totalCostC!),
        unitPrice: selectedProduct.value!.unitPrice,
        userId: userModel.uid.toString(),
        firstName: userModel.firstName!,
        imageProduct: selectedProduct.value!.imageProduct!,
      );

      await addProductOrderR.addProductOrderToFireStore(orderProduct);

      Get.snackbar("success", "Add product order success!");
      loadingC.showLoading();
      Future.delayed(Duration(seconds: 2), () {
        loadingC.hideLoading();
        Get.offAndToNamed("warehouse_main_page");
      });
    } catch (e) {
      Get.snackbar("Failed", "$e");
      print(e);
    }
  }

  void getDataRaw() {
    final totalCost =
        selectedProduct.value!.unitPrice * int.parse(quantityC.text);

    productIdC = selectedProduct.value!.id;
    productCodeC = selectedProduct.value!.productCode;
    nameProductC = selectedProduct.value!.productName;
    totalCostC = totalCost.toString();
  }

  void resetControllerInput() {
    financeApproved.clear();
    financeApprovedDate.clear();
    orderDateC.clear();
    quantityC.clear();
    selectedProduct.value = null;
  }
}
