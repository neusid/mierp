import 'package:get/get.dart';

class LoadingViewModel extends GetxController {

  RxBool isVisible = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    Future.delayed(Duration(milliseconds: 200), () => isVisible.value = true);
    super.onInit();
  }
}