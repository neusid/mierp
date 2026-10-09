import os

# 1. Rename OnboardingViewModel to OnboardingService and remove GetX
old_path = r"d:\Project\Flutter\mierp\lib\features\onboarding\presentation\onboarding_view_model.dart"
new_path = r"d:\Project\Flutter\mierp\lib\features\onboarding\presentation\onboarding_service.dart"

code = """import 'package:shared_preferences/shared_preferences.dart';

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
"""
with open(new_path, 'w', encoding='utf-8') as f:
    f.write(code)

if os.path.exists(old_path):
    os.remove(old_path)

# 2. Update injection_container.dart
di_path = r"d:\Project\Flutter\mierp\lib\core\di\injection_container.dart"
with open(di_path, 'r', encoding='utf-8') as f:
    di_code = f.read()

di_code = di_code.replace("import 'package:mierp_apps/features/onboarding/presentation/onboarding_view_model.dart';", "import 'package:mierp_apps/features/onboarding/presentation/onboarding_service.dart';")
di_code = di_code.replace("sl.registerLazySingleton<OnboardingViewModel>(() => Get.find<OnboardingViewModel>());", "sl.registerLazySingleton<OnboardingService>(() => OnboardingService());")
di_code = di_code.replace("onboardingViewModel: sl(),", "onboardingService: sl(),")

with open(di_path, 'w', encoding='utf-8') as f:
    f.write(di_code)

# 3. Update SplashBloc
splash_bloc_path = r"d:\Project\Flutter\mierp\lib\features\splash\presentation\bloc\splash_bloc.dart"
with open(splash_bloc_path, 'r', encoding='utf-8') as f:
    splash_bloc = f.read()

splash_bloc = splash_bloc.replace("import 'package:mierp_apps/features/onboarding/presentation/onboarding_view_model.dart';", "import 'package:mierp_apps/features/onboarding/presentation/onboarding_service.dart';")
splash_bloc = splash_bloc.replace("final OnboardingViewModel onboardingViewModel;", "final OnboardingService onboardingService;")
splash_bloc = splash_bloc.replace("required this.onboardingViewModel", "required this.onboardingService")
splash_bloc = splash_bloc.replace("final isFirstLaunch = await onboardingViewModel.isFirstLaunch();", "final isFirstLaunch = await onboardingService.isFirstLaunch();")

with open(splash_bloc_path, 'w', encoding='utf-8') as f:
    f.write(splash_bloc)

print("OnboardingViewModel refactored to OnboardingService")
