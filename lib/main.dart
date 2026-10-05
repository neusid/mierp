import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/bindings/global_binding.dart';
import 'package:mierp_apps/core/routing/app_routes.dart';
import 'package:mierp_apps/core/di/injection_container.dart' as di;

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(MierpApps());
}

class MierpApps extends StatelessWidget {
  MierpApps({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          smartManagement: SmartManagement.full,
          initialRoute: '/splash',
          getPages: AppRoutes.pages,
          initialBinding: GlobalBinding(),
        );
      },
    );
  }
}
