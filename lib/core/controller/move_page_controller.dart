import 'package:get/get.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';

class MovePageController extends GetxController {

  final loading = Get.find<LoadingController>();

  Future<void> movePage(page) async {
    loading.showLoading();
    Future.delayed(Duration(seconds: 1,), () async {
      loading.hideLoading();
      return Get.offAllNamed(page);
    });
  }

  Future<void> movePageWithBack(page) async {
    loading.showLoading();
    Future.delayed(Duration(seconds: 1,), () async {
      loading.hideLoading();
      return Get.toNamed(page);
    });
  }

  Future<void> movePageBack() async {
    loading.showLoading();
    Future.delayed(Duration(seconds: 1,), () async {
      loading.hideLoading();
      return Get.back();
    });
  }
}