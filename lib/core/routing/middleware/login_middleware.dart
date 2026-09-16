import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/core/session/auth_session.dart';

class LoginMiddleware extends GetMiddleware{
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthSession>();
    if (!auth.isLoggedIn.value) {
      return const RouteSettings(name: "/login");
    }
    return null;
  }
}