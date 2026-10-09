import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  bool isFirst = true;

  Future<void> initFirstLaunch() async {
    await isFirstLaunch();
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('is_first_run') ?? true;

    isFirst = isFirstRun;

    if(isFirstRun){
      await prefs.setBool('is_first_run', false);
    }
    return isFirstRun;
  }
}
