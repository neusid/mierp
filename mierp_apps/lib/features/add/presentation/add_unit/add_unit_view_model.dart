import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/data/warehouse/services/add_unit_services.dart';

class AddUnitViewModel extends GetxController {
  final AddUnitServices addUnitServices;

  AddUnitViewModel({required this.addUnitServices});

  final productCodeC = TextEditingController();
  final nameProductC = TextEditingController();
  final createdOnC = TextEditingController();
  final quantityC = TextEditingController();
  final unitPriceC = TextEditingController();
  var imageFile = Rxn<XFile>();

  RxString categoryProductC = "electronics".obs;
  RxBool isLoading = false.obs;

  final loadingC = Get.find<LoadingController>();
  final movePage = Get.find<MovePageController>();

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
        createdOnC.text = formatDateTime;
      }
    }
  }

  // Future<void> requestPostDataProduct() async {
  //   try {
  //     isLoading.value = true;
  //
  //     Product product = Product(
  //       category: categoryProductC.value,
  //       createdOn: createdOnC.text,
  //       imageProduct: "",
  //       productName: nameProductC.text,
  //       productCode: productCodeC.text,
  //       quantity: int.parse(quantityC.text),
  //       unitPrice: int.parse(unitPriceC.text),
  //       id: "",
  //     );
  //
  //     await addUnitServices.postDataProduct(product);
  //
  //     Future.delayed(Duration(seconds: 2), () {
  //       isLoading.value = false;
  //       loadingC.hideLoading();
  //       Get.snackbar("Success", "Success add unit!");
  //       resetControllerInput();
  //     });
  //   } catch (e) {
  //     isLoading.value = false;
  //     Get.snackbar("Failed", "Failed add unit!");
  //     resetControllerInput();
  //   }
  // }

  Future<void> requestPostDataProduct() async {
    try {
      isLoading.value = true;
      loadingC.showLoading();

      String? imageUrl = "";

      if (imageFile.value != null) {
        imageUrl = await addUnitServices.postDataImage(imageFile.value!);
      }

      Product product = Product(
        category: categoryProductC.value,
        createdOn: createdOnC.text,
        imageProduct: imageUrl,
        productName: nameProductC.text,
        productCode: productCodeC.text,
        quantity: int.parse(quantityC.text),
        unitPrice: int.parse(unitPriceC.text),
        id: "",
      );

      await addUnitServices.postDataProduct(product);

      isLoading.value = false;
      loadingC.hideLoading();
      Get.snackbar("Success", "Berhasil menambah produk!");
      resetControllerInput();
      imageFile.value = null;
    } catch (e) {
      isLoading.value = false;
      loadingC.hideLoading();
      Get.snackbar("Error", e.toString());
      print("Error Detail: $e");
    }
  }

  void resetControllerInput() {
    productCodeC.clear();
    nameProductC.clear();
    createdOnC.clear();
    quantityC.clear();
    unitPriceC.clear();
    categoryProductC.value = "electronics";
  }
}
