import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  bool isFirst = true;

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('is_first_run') ?? true;
    isFirst = isFirstRun;
    return isFirstRun;
  }

  Future<void> completeFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_run', false);
    isFirst = false;
  }
}

