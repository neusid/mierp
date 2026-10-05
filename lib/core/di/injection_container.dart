import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/session/auth_session.dart';
import 'package:mierp_apps/domain/credential/repository/credential_repository.dart';
import 'package:mierp_apps/features/login/data/repositories/login_repository_impl.dart';
import 'package:mierp_apps/features/login/domain/repositories/login_repository.dart';
import 'package:mierp_apps/features/login/domain/usecases/do_login.dart';
import 'package:mierp_apps/features/login/presentation/bloc/login_bloc.dart';
import 'package:mierp_apps/features/onboarding/presentation/onboarding_view_model.dart';
import 'package:mierp_apps/features/splash/presentation/bloc/splash_bloc.dart';

import 'package:mierp_apps/features/register/data/repositories/register_repository_impl.dart';
import 'package:mierp_apps/features/register/domain/repositories/register_repository.dart';
import 'package:mierp_apps/features/register/domain/usecases/do_register.dart';
import 'package:mierp_apps/features/register/presentation/bloc/register_bloc.dart';

import 'package:mierp_apps/features/forgot_password/data/repositories/forgot_password_repository_impl.dart';
import 'package:mierp_apps/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:mierp_apps/features/forgot_password/domain/usecases/do_reset_password.dart';
import 'package:mierp_apps/features/forgot_password/presentation/bloc/forgot_password_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// --------------------------------------------------------------------------
  /// CORE & NETWORK FOUNDATION (Bridging from GetX)
  /// --------------------------------------------------------------------------
  sl.registerLazySingleton<AuthSession>(() => Get.find<AuthSession>());
  sl.registerLazySingleton<OnboardingViewModel>(() => Get.find<OnboardingViewModel>());
  sl.registerLazySingleton<CredentialRepository>(() => Get.find<CredentialRepository>());
  sl.registerLazySingleton(() => UserDataController()); // Instansiasi baru
  
  /// --------------------------------------------------------------------------
  /// AUTHENTICATION FLOW (Splash & Login)
  /// --------------------------------------------------------------------------
  // BLoC
  sl.registerFactory(() => SplashBloc(
        authSession: sl(),
        onboardingViewModel: sl(),
      ));
      
  sl.registerFactory(() => LoginBloc(
        doLogin: sl(),
        doLoginWithGoogle: sl(),
        credentialRepository: sl(),
        userDataController: sl(),
      ));
  
  sl.registerFactory(() => RegisterBloc(doRegister: sl()));
  sl.registerFactory(() => ForgotPasswordBloc(doResetPassword: sl()));
  
  // UseCases
  sl.registerLazySingleton(() => DoLogin(sl()));
  sl.registerLazySingleton(() => DoLoginWithGoogle(sl()));
  sl.registerLazySingleton(() => DoRegister(sl()));
  sl.registerLazySingleton(() => DoResetPassword(sl()));

  // Repository (Contracts & Implementations)
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl());
  sl.registerLazySingleton<RegisterRepository>(() => RegisterRepositoryImpl());
  sl.registerLazySingleton<ForgotPasswordRepository>(() => ForgotPasswordRepositoryImpl());
  
  /// --------------------------------------------------------------------------
  /// MAIN FEATURE FLOW (Dashboard & Transaksi)
  /// --------------------------------------------------------------------------
}
