
import 'package:get/get.dart';

class WarehouseMainPageViewModel extends GetxController {
  RxInt currentIndex = 0.obs;

  void goToDashboard() {
    currentIndex.value = 0;
  }

  void goToProfile() {
    currentIndex.value = 1;
  }
}