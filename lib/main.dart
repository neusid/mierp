import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mierp_apps/core/routing/app_router.dart';
import 'package:mierp_apps/core/di/injection_container.dart' as di;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mierp_apps/core/services/fcm_notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await di.init();
  await di.sl<FcmNotificationService>().init();
  runApp(const MierpApps());
}

class MierpApps extends StatelessWidget {
  const MierpApps({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationCubit>(
      create: (_) => di.sl<NotificationCubit>()..init(),
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
