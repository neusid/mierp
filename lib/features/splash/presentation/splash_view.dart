import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/features/splash/presentation/bloc/splash_bloc.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Memulai proses splash saat widget diinisialisasi
    context.read<SplashBloc>().add(SplashStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToOnboarding) {
          Get.offAllNamed('/onboarding');
        } else if (state is SplashNavigateToLogin) {
          Get.offAllNamed('/login');
        } else if (state is SplashNavigateToWarehouse) {
          Get.offAllNamed('/warehouse_main_page');
        } else if (state is SplashNavigateToFinance) {
          Get.offAllNamed('/finance_main_page');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset("assets/images/mierp.png", width: 100),
        ),
      ),
    );
  }
}

