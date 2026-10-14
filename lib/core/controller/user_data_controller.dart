import 'dart:convert';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataController {

  Future<UserModel> getDataUser() async {
    try {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      final userDataRaw = sharedPreferences.getString("user");
      final userData = jsonDecode(userDataRaw!);

      return UserModel.fromJson(userData);
    } catch(e) {
      rethrow;
    }
  }

  Future<void> setDataUser(UserModel userModel) async {
    try {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('user', jsonEncode(userModel.toJson()));
    } catch(e) {
      rethrow;
    }
  }

  Future<String> getEffectiveAdminId() async {
    try {
      final user = await getDataUser();
      return user.effectiveAdminId;
    } catch (_) {
      return '';
    }
  }
}