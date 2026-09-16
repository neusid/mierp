
import 'package:get/get.dart';

class FinanceMainPageViewModel extends GetxController {

  RxInt currentIndex = 0.obs;

  void goToDashboard() {
    currentIndex.value = 0;
  }

  void goToProfile() {
    currentIndex.value = 1;
  }
}