import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/data/forgot_password/forgot_password_repository.dart';

class ForgotPasswordViewModel extends GetxController {

  ForgotPasswordRepository forgotPasswordRepository;
  ForgotPasswordViewModel({required this.forgotPasswordRepository});

  final formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final focusNode = FocusNode();

  RxBool hasError = false.obs;
  RxBool isFocus = false.obs;
  RxBool isLoading = false.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    focusNode.addListener(() => isFocus.value = focusNode.hasFocus,);
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    super.dispose();
  }

  Future<void> requestResetPassword() async {
    try {
      isLoading.value = true;
      forgotPasswordRepository.sendPasswordResetVerification(emailC.text);
      Future.delayed(Duration(seconds: 1), () => Get.snackbar("Success", "Check your email"),);
      isLoading.value = false;
      Get.back();
    } catch(e) {
      isLoading.value = false;
      Get.snackbar("Failed", "$e");
    }
  }
}