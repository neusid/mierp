import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mierp_apps/features/splash/presentation/splash_view_model.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  final splashC = Get.find<SplashViewModel>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/images/mierp.png", width: 100,),
      ),
    );
  }
}

