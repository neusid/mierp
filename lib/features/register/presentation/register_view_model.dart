import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/data/register/register_repository.dart';

class RegisterViewModel extends GetxController {

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController firstNameC = TextEditingController();
  TextEditingController lastNameC = TextEditingController();
  final registerR = Get.put(RegisterRepository());
  final loadingC = Get.put(LoadingController());
  RxString roleC = "warehouse".obs;

  Future<void> RegisterWithEmailPassword() async {
    try {
      loadingC.showLoading();
      UserCredential data = await registerR.CreateNewAccount(emailC.text, passwordC.text, firstNameC.text, lastNameC.text, roleC.value);
      final uid = data.user!.uid;
      await registerR.AddNewFstoreData(uid,emailC.text,firstNameC.text,lastNameC.text, roleC.value);
      await registerR.firebaseAuth.signOut();
      Get.snackbar("Register Success", "Your account has benn created!.");
      Future.delayed(Duration(seconds: 3), () {
        loadingC.hideLoading();
        resetController();
        Get.offAllNamed("/login");
      },);
    } catch(e) {
      loadingC.hideLoading();
      Get.snackbar("Register Info", "$e.");
    }
  }

  void resetController() {
    emailC.clear();
    passwordC.clear();
  }
}

