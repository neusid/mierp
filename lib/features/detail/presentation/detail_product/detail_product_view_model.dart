import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/data/finance/services/detail_product_services.dart';
import 'package:mierp_apps/data/warehouse/detail/detail_product_repository.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/state/item_store.dart';

class DetailProductViewModel extends GetxController {
  final id;
  final ItemRepository itemRepository;
  final ItemStore itemStore;
  final DetailProductServices detailProductServices;
  DetailProductViewModel({
    required this.id,
    required this.itemRepository,
    required this.itemStore,
    required this.detailProductServices,
  });

  final detailProductR = DetailProductRepository();
  final loadingC = Get.find<LoadingController>();

  RxBool isLoading = false.obs;

  TextEditingController productCodeC = TextEditingController();
  TextEditingController nameProductC = TextEditingController();
  TextEditingController createdOnC = TextEditingController();
  TextEditingController quantityC = TextEditingController();
  TextEditingController unitPriceC = TextEditingController();
  RxString categoryProductC = "electronics".obs;
  RxString imageProduct = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getDetailProduct();
    super.onInit();
  }

  Rxn<Product> get detailProduct {
    return itemStore.products;
  }

  Future<void> getDetailProduct() async {
    try {
      isLoading.value = true;
      await itemRepository.getDetailDataStock(id);
      updateDataController();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Failed", "$e");
    }
  }

  void updateDataController() {
    productCodeC.text = detailProduct.value!.productCode;
    nameProductC.text = detailProduct.value!.productName;
    createdOnC.text = detailProduct.value!.createdOn;
    quantityC.text = detailProduct.value!.quantity.toString();
    unitPriceC.text = detailProduct.value!.unitPrice.toString();
    imageProduct.value = detailProduct.value!.imageProduct!;
    categoryProductC.value = detailProduct.value!.category;
  }

  Future<void> updateSingleProduct() async {
    try {
      isLoading.value = true;
      Product product = Product(
        id: detailProduct.value!.id,
        category: categoryProductC.value,
        createdOn: createdOnC.text,
        imageProduct: detailProduct.value!.imageProduct!,
        productName: nameProductC.text,
        productCode: productCodeC.text,
        quantity: int.parse(quantityC.text),
        unitPrice: int.parse(unitPriceC.text),
      );
      await detailProductServices.updateDataProduct(
        detailProduct.value!.id,
        product,
      );
      isLoading.value = false;
      Get.snackbar("Success", "Update data success");
    } catch (e) {
      Get.snackbar("Failed", "$e");
    }
  }

  Future<void> delete() async {
    try {
      isLoading.value = true;
      await detailProductServices.deleteDataProduct(detailProduct.value!.id);
      await itemRepository.getBulkDataStock();
      Future.delayed(Duration(seconds: 2), () {
        Get.snackbar("Success", "Delete data success");
        isLoading.value = false;
        Get.toNamed("warehouse_main_page");
      });
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Failed", "$e");
    }
  }

  void moveBack() {
    isLoading.value = true;
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      Get.back();
    });
  }
}
