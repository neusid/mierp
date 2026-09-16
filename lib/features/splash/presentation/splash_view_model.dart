import 'dart:convert';

import 'package:get/get.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/core/session/auth_session.dart';
import 'package:mierp_apps/features/onboarding/presentation/onboarding_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewModel extends GetxController {

  final AuthSession authSession;
  final OnboardingViewModel onboardingViewModel;

  SplashViewModel({required this.authSession, required this.onboardingViewModel});

  @override
  void onReady() {
    super.onReady();
    Future.microtask(() => _init(),);
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2), () {

      if (!authSession.isLoggedIn.value) {
        Get.offAllNamed("/login");
        return;
      }
      print("Check Prefs: ${prefs.getString("user")}");

      final dataUserRaw = prefs.getString("user");
      Map<String,dynamic> dataUserJson = jsonDecode(dataUserRaw!);

      final dataUser = UserModel.fromJson(dataUserJson);

      if(dataUser!.role == "warehouse"){
        Get.offAllNamed("/warehouse_main_page");
      }else{
        Get.offAllNamed("/finance_main_page");
      }
    });
  }

  Future<void> _init() async {
    final isFirst = onboardingViewModel.isFirst;
    if (isFirst.value) {
      Future.delayed(Duration(seconds: 2),() {
        Get.offAllNamed('/onboarding');
      });
    } else {
      checkLogin();
    }
  }
}