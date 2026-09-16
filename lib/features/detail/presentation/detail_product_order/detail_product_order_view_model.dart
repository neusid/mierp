import 'package:get/get.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/data/transaction/services/transaction_services.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/data/warehouse/detail/detail_product_order_repository.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/state/item_store.dart';


class DetailProductOrderViewModel extends GetxController {

  final id;
  final ItemRepository itemRepository;
  final ItemStore itemStore;
  final TransactionServices transactionServices;

  DetailProductOrderViewModel({required this.id, required this.itemRepository, required this.itemStore, required this.transactionServices});

  final totalCost = "".obs;
  final unitPrice = "".obs;

  final detailProductOrderR = DetailProductOrderRepository();
  final loadingC = Get.find<LoadingController>();
  final movePageC = Get.find<MovePageController>();
  final convertDollar = ConvertDollar();
  final userDataC = UserDataController();

  RxBool success = false.obs;
  RxString errorMessage = "".obs;

  Rxn role = Rxn();
  RxBool isLoading = false.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    itemRepository.getDetailDataOrder(id);
    getRoleUser();
  }

  Rxn<OrderProduct> get orderProducts {
    return itemStore.orderProducts;
  }


  Future<void> getRoleUser() async {
    UserModel user = await userDataC.getDataUser();
    role.value = user.role;
  }


  Future<void> requestPayProductOrder(docId, prodId, totalQty) async {
    try {
      isLoading.value = true;

      await transactionServices.payProductOrderServices(docId, prodId, totalQty);
      await itemRepository.getDetailDataOrder(docId);

      success.value = true;
      isLoading.value = false;
    } catch(e) {
      isLoading.value = false;
      Get.snackbar("Failed", "$e");
    }
  }

  Future<void> requestDeleteProductOrder(docId) async {
    try {
      isLoading.value = true;
      await detailProductOrderR.deleteSingleProduct(docId);
      await itemRepository.getBulkDataOrder();
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