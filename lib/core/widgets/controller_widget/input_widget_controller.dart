import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputWidgetController extends GetxController {

  FocusNode focusAuthNode = FocusNode();
  FocusNode focusNode = FocusNode();
  RxBool isFocus = false.obs;
  RxBool isNotVisible = true.obs;
  RxString eCode = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    focusAuthNode.addListener(() => isFocus.value = focusAuthNode.hasFocus);
    super.onInit();
  }


  @override
  void onClose() {
    // TODO: implement onClose
    focusAuthNode.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void changeIsNotVisible() => isNotVisible.value = !isNotVisible.value;
}