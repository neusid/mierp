import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel extends GetxController {

  final isFirst = true.obs;

  @override
  void onInit() {
    // TODO: implement
    super.onInit();
    _initFirstLaunch();
  }

  Future<void> _initFirstLaunch() async {
    await isFirstLaunch();
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('is_first_run') ?? true;

    isFirst.value = isFirstRun;

    if(isFirstRun){
      await prefs.setBool('is_first_run', false);
    }
    return isFirstRun;
  }
}